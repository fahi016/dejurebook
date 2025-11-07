import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum LawyerPracticeArea {
  businessLaw('Business Law'),
  criminalLaw('Criminal Law'),
  civilLaw('Civil Law'),
  familyLaw('Family Law'),
  labourLaw('Labour Law'),
  ipLaw('IP Law');

  const LawyerPracticeArea(this.label);

  final String label;
}

enum LawyerWeekday {
  monday('Mon.'),
  tuesday('Tue.'),
  wednesday('Wed.'),
  thursday('Thu.'),
  friday('Fri.'),
  saturday('Sat.'),
  sunday('Sun.');

  const LawyerWeekday(this.shortLabel);

  final String shortLabel;

  String get dbValue => name;

  static LawyerWeekday fromDbValue(String value) {
    return LawyerWeekday.values.firstWhere(
      (weekday) => weekday.name == value,
      orElse: () => LawyerWeekday.monday,
    );
  }
}

class LawyerAvailabilitySlot extends Equatable {
  const LawyerAvailabilitySlot({
    required this.start,
    required this.end,
  });

  final TimeOfDay start;
  final TimeOfDay end;

  LawyerAvailabilitySlot copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
  }) {
    return LawyerAvailabilitySlot(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': _encodeTimeOfDay(start),
      'end': _encodeTimeOfDay(end),
    };
  }

  static LawyerAvailabilitySlot fromJson(Map<String, dynamic> json) {
    return LawyerAvailabilitySlot(
      start: _decodeTimeOfDay(json['start'] as String),
      end: _decodeTimeOfDay(json['end'] as String),
    );
  }

  static String _encodeTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay _decodeTimeOfDay(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  List<Object?> get props => [start.hour, start.minute, end.hour, end.minute];
}

class LawyerProfile extends Equatable {
  const LawyerProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.languages,
    required this.practiceAreas,
    required this.education,
    required this.experienceYears,
    required this.linkedinUrl,
    required this.availability,
    required this.applicationFee,
    this.documentUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final List<String> languages;
  final List<LawyerPracticeArea> practiceAreas;
  final String education;
  final int experienceYears;
  final String linkedinUrl;
  final Map<LawyerWeekday, List<LawyerAvailabilitySlot>> availability;
  final double applicationFee;
  final String? documentUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LawyerProfile copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    List<String>? languages,
    List<LawyerPracticeArea>? practiceAreas,
    String? education,
    int? experienceYears,
    String? linkedinUrl,
    Map<LawyerWeekday, List<LawyerAvailabilitySlot>>? availability,
    double? applicationFee,
    String? documentUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LawyerProfile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      languages: languages ?? this.languages,
      practiceAreas: practiceAreas ?? this.practiceAreas,
      education: education ?? this.education,
      experienceYears: experienceYears ?? this.experienceYears,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      availability: availability ?? this.availability,
      applicationFee: applicationFee ?? this.applicationFee,
      documentUrl: documentUrl ?? this.documentUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'languages': languages,
      'practice_areas': practiceAreas.map((area) => area.name).toList(),
      'education': education,
      'experience_years': experienceYears,
      'linkedin_url': linkedinUrl,
      'availability': availability.map((key, value) => MapEntry(
            key.dbValue,
            value.map((slot) => slot.toJson()).toList(),
          )),
      'application_fee': applicationFee,
      'document_url': documentUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory LawyerProfile.fromJson(Map<String, dynamic> json) {
    return LawyerProfile(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      languages: (json['languages'] as List<dynamic>? ?? [])
          .map((lang) => lang as String)
          .toList(),
      practiceAreas: (json['practice_areas'] as List<dynamic>? ?? [])
          .map((area) => LawyerPracticeArea.values.firstWhere(
                (value) => value.name == area,
                orElse: () => LawyerPracticeArea.businessLaw,
              ))
          .toList(),
      education: json['education'] as String? ?? '',
      experienceYears: (json['experience_years'] as num?)?.toInt() ?? 0,
      linkedinUrl: json['linkedin_url'] as String? ?? '',
      availability:
          (json['availability'] as Map<String, dynamic>? ?? <String, dynamic>{})
              .map((key, value) => MapEntry(
                    LawyerWeekday.fromDbValue(key),
                    (value as List<dynamic>)
                        .map((slot) {
                          final slotMap =
                              Map<String, dynamic>.from(slot as Map);
                          return LawyerAvailabilitySlot.fromJson(slotMap);
                        })
                        .toList(),
                  )),
      applicationFee: (json['application_fee'] as num?)?.toDouble() ?? 0,
      documentUrl: json['document_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        phoneNumber,
        languages,
        practiceAreas,
        education,
        experienceYears,
        linkedinUrl,
        availability,
        applicationFee,
        documentUrl,
        createdAt,
        updatedAt,
      ];
}

