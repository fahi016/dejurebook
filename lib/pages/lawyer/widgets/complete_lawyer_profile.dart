import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/bloc/auth_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/lawyer_constants.dart';
import 'package:dejurebook/models/lawyer_profile.dart';
import 'package:dejurebook/models/user_profile.dart';
import 'package:dejurebook/pages/lawyer/lawyer_home_page.dart';
import 'package:dejurebook/pages/lawyer/widgets/availability_day_card.dart';
import 'package:dejurebook/pages/lawyer/widgets/document_upload_card.dart';
import 'package:dejurebook/pages/lawyer/widgets/payment_summary_card.dart';
import 'package:dejurebook/pages/lawyer/widgets/practice_area_chip.dart';
import 'package:dejurebook/pages/lawyer/widgets/section_header.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/services/lawyer_profile_service.dart';
import 'package:dejurebook/services/profile_service.dart';

class CompleteLawyerProfilePage extends StatefulWidget {
  const CompleteLawyerProfilePage({super.key});

  @override
  State<CompleteLawyerProfilePage> createState() =>
      _CompleteLawyerProfilePageState();
}

class _CompleteLawyerProfilePageState extends State<CompleteLawyerProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _languagesController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _upiController = TextEditingController();

  Set<LawyerPracticeArea> _selectedPracticeAreas = {
    LawyerPracticeArea.businessLaw,
    LawyerPracticeArea.ipLaw,
  };
  Map<LawyerWeekday, List<LawyerAvailabilitySlot>> _availability = {};

  bool _isLoading = true;
  bool _isSubmitting = false;
  Uint8List? _documentBytes;
  String? _documentFileName;
  String? _documentFileSizeLabel;
  String? _documentUrl;

  LawyerPaymentMethod _selectedPaymentMethod = LawyerPaymentMethod.upi;

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
    _loadProfile();
  }

  void _initializeDefaults() {
    _availability = {
      for (final weekday in LawyerWeekday.values)
        weekday: _defaultSlotsForDay(weekday),
    };
  }

  List<LawyerAvailabilitySlot> _defaultSlotsForDay(LawyerWeekday weekday) {
    if (weekday == LawyerWeekday.saturday || weekday == LawyerWeekday.sunday) {
      return [];
    }
    return [
      const LawyerAvailabilitySlot(
        start: TimeOfDay(hour: 9, minute: 0),
        end: TimeOfDay(hour: 13, minute: 0),
      ),
      const LawyerAvailabilitySlot(
        start: TimeOfDay(hour: 14, minute: 0),
        end: TimeOfDay(hour: 18, minute: 0),
      ),
    ];
  }

  Future<void> _loadProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found.');
      }

      final profile = await ProfileService.getProfile(user.id);
      if (profile != null) {
        _hydrateFromUserProfile(profile);
      } else {
        _emailController.text = user.email ?? '';
      }

      final lawyerProfile = await LawyerProfileService.fetchProfile(user.id);
      if (lawyerProfile != null) {
        _hydrateFromLawyerProfile(lawyerProfile);
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _hydrateFromUserProfile(UserProfile profile) {
    _fullNameController.text = profile.fullName ?? '';
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
  }

  void _hydrateFromLawyerProfile(LawyerProfile profile) {
    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _languagesController.text = profile.languages.join(', ');
    _educationController.text = profile.education;
    _experienceController.text = profile.experienceYears.toString();
    _linkedinController.text = profile.linkedinUrl;
    _documentUrl = profile.documentUrl;
    _documentFileName = null;
    _documentFileSizeLabel = null;
    _documentBytes = null;

    _selectedPracticeAreas = profile.practiceAreas.toSet();
    _availability = {
      for (final entry in profile.availability.entries) entry.key: entry.value,
    };
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _languagesController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _linkedinController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: LawyerConstants.supportedFileExtensions,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      _showError('Unable to read selected file.');
      return;
    }

    final sizeInBytes = bytes.length;
    final sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > LawyerConstants.maxUploadSizeInMb) {
      _showError(
          'File is larger than ${LawyerConstants.maxUploadSizeInMb} MB.');
      return;
    }

    setState(() {
      _documentFileName = file.name;
      _documentFileSizeLabel = '${sizeInMb.toStringAsFixed(2)} MB';
      _documentBytes = bytes;
      _documentUrl = null;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPracticeAreas.isEmpty) {
      _showError('Please select at least one practice area.');
      return;
    }

    if (_availability.values.every((slots) => slots.isEmpty)) {
      _showError('Please add availability for at least one day.');
      return;
    }

    if (_documentUrl == null && _documentBytes == null) {
      _showError('Please upload your degree certificate or experience proof.');
      return;
    }

    if (_selectedPaymentMethod == LawyerPaymentMethod.upi &&
        _upiController.text.trim().isEmpty) {
      _showError('Please enter your UPI ID to proceed.');
      return;
    }

    final user = AuthService.currentUser;
    if (user == null) {
      _showError('No authenticated user. Please sign in again.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final languages = _languagesController.text
          .split(',')
          .map((lang) => lang.trim())
          .where((lang) => lang.isNotEmpty)
          .toList();

      String? documentUrl = _documentUrl;
      if (_documentBytes != null && _documentFileName != null) {
        documentUrl = await LawyerProfileService.uploadDocument(
          userId: user.id,
          originalFileName: _documentFileName!,
          fileBytes: _documentBytes!,
        );
      }

      await ProfileService.updateProfile(
        userId: user.id,
        fullName: _fullNameController.text.trim(),
        profession: 'Lawyer',
        userType: 'lawyer',
        phoneNumber: _phoneController.text.trim(),
      );

      final lawyerProfile = LawyerProfile(
        userId: user.id,
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        languages: languages,
        practiceAreas: _selectedPracticeAreas.toList(),
        education: _educationController.text.trim(),
        experienceYears: int.tryParse(_experienceController.text.trim()) ?? 0,
        linkedinUrl: _linkedinController.text.trim(),
        availability: _availability,
        applicationFee: LawyerConstants.verificationFee,
        documentUrl: documentUrl,
      );

      await LawyerProfileService.upsertProfile(lawyerProfile);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LawyerHomePage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error submitting lawyer profile: $e');
      if (mounted) {
        _showError('Failed to save profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _pickStartTime(LawyerWeekday day, int index) async {
    final current = _availability[day]![index].start;
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
    );

    if (picked != null) {
      setState(() {
        final slots = [..._availability[day]!];
        slots[index] = slots[index].copyWith(start: picked);
        _availability = {
          ..._availability,
          day: slots,
        };
      });
    }
  }

  Future<void> _pickEndTime(LawyerWeekday day, int index) async {
    final current = _availability[day]![index].end;
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
    );

    if (picked != null) {
      setState(() {
        final slots = [..._availability[day]!];
        slots[index] = slots[index].copyWith(end: picked);
        _availability = {
          ..._availability,
          day: slots,
        };
      });
    }
  }

  void _addSlot(LawyerWeekday day) {
    setState(() {
      final slots = [..._availability[day]!];
      slots.add(
        const LawyerAvailabilitySlot(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
      );
      _availability = {
        ..._availability,
        day: slots,
      };
    });
  }

  void _duplicateFromPreviousDay(LawyerWeekday day) {
    final index = LawyerWeekday.values.indexOf(day);
    if (index <= 0) return;

    final previousDay = LawyerWeekday.values[index - 1];
    final previousSlots = _availability[previousDay];
    if (previousSlots == null || previousSlots.isEmpty) return;

    setState(() {
      _availability = {
        ..._availability,
        day: previousSlots
            .map(
              (slot) => LawyerAvailabilitySlot(
                start: slot.start,
                end: slot.end,
              ),
            )
            .toList(),
      };
    });
  }

  void _removeSlot(LawyerWeekday day, int index) {
    setState(() {
      final slots = [..._availability[day]!];
      slots.removeAt(index);
      _availability = {
        ..._availability,
        day: slots,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLight,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceLight,
          elevation: 0,
          title: const Text(
            'Join Awaaz as a Lawyer',
            style: TextStyle(
              color: AppColors.blackShade60,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Help people understand the law. Guide them with clarity. No courtroom, just conversations.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Basic Info'),
                  const SizedBox(height: 16),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 32),
                  SectionHeader(
                    title: 'Practice Area Expertise',
                    subtitle: 'Choose atleast one option',
                  ),
                  const SizedBox(height: 16),
                  _buildPracticeAreas(),
                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Credentials'),
                  const SizedBox(height: 16),
                  _buildCredentialsSection(),
                  const SizedBox(height: 24),
                  DocumentUploadCard(
                    onPickFile: _pickDocument,
                    fileName: _documentFileName ?? _documentUrl,
                    fileSizeLabel: _documentFileSizeLabel,
                  ),
                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Availability'),
                  const SizedBox(height: 16),
                  _buildAvailabilitySection(),
                  const SizedBox(height: 32),
                  PaymentSummaryCard(
                    feeBreakdown: LawyerConstants.feeBreakdown,
                    totalFee: LawyerConstants.verificationFee,
                    selectedMethod: _selectedPaymentMethod,
                    onMethodChanged: (method) {
                      setState(() => _selectedPaymentMethod = method);
                    },
                    upiController: _upiController,
                    onPayNow: _submitProfile,
                    isSubmitting: _isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _fullNameController,
          label: 'What is your Full Name?',
          validator: (value) =>
              value == null || value.isEmpty ? 'Name is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email ID',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (value.length < 10) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _languagesController,
          label: 'Languages Spoken',
          hintText: 'English, Hindi, Telugu',
        ),
      ],
    );
  }

  Widget _buildCredentialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _educationController,
          label: 'Education Qualification (LLB/LLM)',
          validator: (value) =>
              value == null || value.isEmpty ? 'Education is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _experienceController,
          label: 'Years of Experience in Legal Advisory',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Experience is required';
            }
            final numValue = int.tryParse(value);
            if (numValue == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _linkedinController,
          label: 'LinkedIn / Website',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'LinkedIn or website is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPracticeAreas() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: LawyerConstants.practiceAreas.map((area) {
        final isSelected = _selectedPracticeAreas.contains(area);
        return PracticeAreaChip(
          label: area.label,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedPracticeAreas.remove(area);
              } else {
                _selectedPracticeAreas.add(area);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      children: LawyerWeekday.values.map((day) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: day == LawyerWeekday.values.last ? 0 : 16),
          child: AvailabilityDayCard(
            weekday: day,
            slots: _availability[day] ?? [],
            onAddSlot: () => _addSlot(day),
            onDuplicate: () => _duplicateFromPreviousDay(day),
            onRemoveSlot: (index) => _removeSlot(day, index),
            onStartTimeTap: (index) => _pickStartTime(day, index),
            onEndTimeTap: (index) => _pickEndTime(day, index),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.blackShade60,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.blackShade60),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
