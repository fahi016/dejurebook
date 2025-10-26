// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isVerified: json['isVerified'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImageUrl': instance.profileImageUrl,
      'phoneNumber': instance.phoneNumber,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'profile': instance.profile,
      'interests': instance.interests,
      'isVerified': instance.isVerified,
      'isPremium': instance.isPremium,
    };

const _$UserTypeEnumMap = {
  UserType.consumer: 'consumer',
  UserType.lawyer: 'lawyer',
  UserType.lawStudent: 'law_student',
  UserType.admin: 'admin',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.inactive: 'inactive',
  UserStatus.suspended: 'suspended',
  UserStatus.pendingVerification: 'pending_verification',
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      website: json['website'] as String?,
      specialization: json['specialization'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      barAssociation: json['barAssociation'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      practiceAreas: (json['practiceAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      totalCases: (json['totalCases'] as num?)?.toInt(),
      successfulCases: (json['successfulCases'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'location': instance.location,
      'website': instance.website,
      'specialization': instance.specialization,
      'experienceYears': instance.experienceYears,
      'barAssociation': instance.barAssociation,
      'licenseNumber': instance.licenseNumber,
      'languages': instance.languages,
      'practiceAreas': instance.practiceAreas,
      'rating': instance.rating,
      'totalCases': instance.totalCases,
      'successfulCases': instance.successfulCases,
    };
