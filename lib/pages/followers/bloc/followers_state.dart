import 'package:equatable/equatable.dart';

class FollowersState extends Equatable {
  final int currentTabIndex; // 0 for Followers, 1 for Following
  final List<UserItem> followers;
  final List<UserItem> following;
  final bool isLoading;
  final String? error;

  const FollowersState({
    this.currentTabIndex = 0,
    this.followers = const [],
    this.following = const [],
    this.isLoading = false,
    this.error,
  });

  FollowersState copyWith({
    int? currentTabIndex,
    List<UserItem>? followers,
    List<UserItem>? following,
    bool? isLoading,
    String? error,
  }) {
    return FollowersState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        currentTabIndex,
        followers,
        following,
        isLoading,
        error,
      ];
}

class UserItem extends Equatable {
  final String id;
  final String username;
  final String? profileImageUrl;

  const UserItem({
    required this.id,
    required this.username,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, username, profileImageUrl];
}
