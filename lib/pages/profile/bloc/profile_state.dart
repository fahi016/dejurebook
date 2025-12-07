import 'package:equatable/equatable.dart';
import 'package:dejurebook/models/lawyer_profile.dart';
import 'package:dejurebook/models/user_profile.dart';

class ProfileState extends Equatable {
  final String? name;
  final String? location;
  final String? profession;
  final String? joinDate;
  final int followersCount;
  final bool isFollowing;
  final bool isLoading;
  final String? error;
  final UserProfile? userProfile;
  final LawyerProfile? lawyerProfile;

  const ProfileState({
    this.name,
    this.location,
    this.profession,
    this.joinDate,
    this.followersCount = 0,
    this.isFollowing = false,
    this.isLoading = false,
    this.error,
    this.userProfile,
    this.lawyerProfile,
  });

  ProfileState copyWith({
    String? name,
    String? location,
    String? profession,
    String? joinDate,
    int? followersCount,
    bool? isFollowing,
    bool? isLoading,
    String? error,
    UserProfile? userProfile,
    LawyerProfile? lawyerProfile,
  }) {
    return ProfileState(
      name: name ?? this.name,
      location: location ?? this.location,
      profession: profession ?? this.profession,
      joinDate: joinDate ?? this.joinDate,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userProfile: userProfile ?? this.userProfile,
      lawyerProfile: lawyerProfile ?? this.lawyerProfile,
    );
  }

  @override
  List<Object?> get props => [
        name,
        location,
        profession,
        joinDate,
        followersCount,
        isFollowing,
        isLoading,
        error,
        userProfile,
        lawyerProfile,
      ];
}
