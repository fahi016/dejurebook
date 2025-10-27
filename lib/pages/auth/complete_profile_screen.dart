import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/bloc/auth_bloc.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/pages/user_selection/user_selection.dart';
import 'package:dejurebook/models/user_profile.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String email;
  final String password;

  const CompleteProfileScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us about yourself',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This information will help us personalize your experience.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date of Birth
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Select your date of birth',
                      style: TextStyle(
                        color:
                            _selectedDate != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: _genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Profession Field
                TextFormField(
                  controller: _professionController,
                  decoration: const InputDecoration(
                    labelText: 'Profession',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your profession';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading ? null : _submitProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Complete Profile',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // First sign up the user
      context.read<AuthBloc>().add(
            AuthSignUpRequested(
              email: widget.email,
              password: widget.password,
              metadata: {
                'full_name': _nameController.text.trim(),
                'phone': _phoneController.text.trim(),
                'date_of_birth': _selectedDate?.toIso8601String(),
                'gender': _selectedGender,
                'profession': _professionController.text.trim(),
              },
            ),
          );

      // Wait for authentication to complete by listening to auth state
      final authState = await context.read<AuthBloc>().stream.firstWhere(
            (state) => state is AuthAuthenticated || state is AuthError,
          );

      if (authState is AuthError) {
        throw Exception(authState.message);
      }

      // Create or update profile in database
      final user = AuthService.currentUser;
      if (user != null) {
        debugPrint('Creating/updating profile for user: ${user.id}');
        debugPrint('Name: ${_nameController.text.trim()}');
        debugPrint('Profession: ${_professionController.text.trim()}');

        // Check if profile exists
        final profileExists = await ProfileService.profileExists(user.id);

        UserProfile profile;
        if (profileExists) {
          // Profile exists, update it
          debugPrint('Profile exists, updating...');
          profile = await ProfileService.updateProfile(
            userId: user.id,
            fullName: _nameController.text.trim(),
            profession: _professionController.text.trim(),
          );
        } else {
          // Profile doesn't exist, create it
          debugPrint('Profile does not exist, creating...');
          profile = await ProfileService.createProfile(
            userId: user.id,
            email: widget.email,
            fullName: _nameController.text.trim(),
            profession: _professionController.text.trim(),
          );
        }

        debugPrint('Profile saved: ${profile.fullName}, ${profile.profession}');

        if (!mounted) return;

        // Navigate to user selection
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserSelection(),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in _submitProfile: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
