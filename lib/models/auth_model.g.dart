// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      isVerified: json['isVerified'] as bool,
      isPremium: json['isPremium'] as bool,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpiresAt: DateTime.parse(json['tokenExpiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImageUrl': instance.profileImageUrl,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'isVerified': instance.isVerified,
      'isPremium': instance.isPremium,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenExpiresAt': instance.tokenExpiresAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UserTypeEnumMap = {
  UserType.consumer: 'consumer',
  UserType.lawyer: 'lawyer',
  UserType.lawStudent: 'law_student',
  UserType.admin: 'admin',
};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'rememberMe': instance.rememberMe,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      acceptTerms: json['acceptTerms'] as bool,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'acceptTerms': instance.acceptTerms,
    };

GoogleAuthRequest _$GoogleAuthRequestFromJson(Map<String, dynamic> json) =>
    GoogleAuthRequest(
      googleToken: json['googleToken'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
    );

Map<String, dynamic> _$GoogleAuthRequestToJson(GoogleAuthRequest instance) =>
    <String, dynamic>{
      'googleToken': instance.googleToken,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

PhoneAuthRequest _$PhoneAuthRequestFromJson(Map<String, dynamic> json) =>
    PhoneAuthRequest(
      phoneNumber: json['phoneNumber'] as String,
      verificationCode: json['verificationCode'] as String?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
    );

Map<String, dynamic> _$PhoneAuthRequestToJson(PhoneAuthRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'verificationCode': instance.verificationCode,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordRequest(
      email: json['email'] as String,
    );

Map<String, dynamic> _$ForgotPasswordRequestToJson(
        ForgotPasswordRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

ResetPasswordRequest _$ResetPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordRequest(
      token: json['token'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$ResetPasswordRequestToJson(
        ResetPasswordRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'newPassword': instance.newPassword,
    };

ChangePasswordRequest _$ChangePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequest(
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$ChangePasswordRequestToJson(
        ChangePasswordRequest instance) =>
    <String, dynamic>{
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
    };
