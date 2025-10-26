import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String location;
  final String profession;
  final String joinDate;
  final int followersCount;
  final bool isFollowing;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.name = 'Md Avase',
    this.location = 'Hyderabad, Telangana',
    this.profession = 'Full stack developer',
    this.joinDate = 'Jul 2025',
    this.followersCount = 87,
    this.isFollowing = false,
    this.isLoading = false,
    this.error,
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
      ];
}
