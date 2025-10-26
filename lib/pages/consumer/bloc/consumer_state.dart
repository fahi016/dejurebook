import 'package:equatable/equatable.dart';

class ConsumerState extends Equatable {
  final int currentNavIndex; // Bottom navigation (Home/Awaz/Reels)
  final int
      currentContentTabIndex; // Top tabs (deJure/News/Quires) - only on Home
  final bool isLoading;
  final String? error;
  final bool isVoiceListening; // For Awaz voice listening state
  final List<ReelItem> reels; // For Reels content
  final int currentReelIndex; // Current visible reel
  final bool isVideoPlaying; // Video playback state

  const ConsumerState({
    this.currentNavIndex = 0,
    this.currentContentTabIndex = 0,
    this.isLoading = false,
    this.error,
    this.isVoiceListening = false,
    this.reels = const [],
    this.currentReelIndex = 0,
    this.isVideoPlaying = false,
  });

  ConsumerState copyWith({
    int? currentNavIndex,
    int? currentContentTabIndex,
    bool? isLoading,
    String? error,
    bool? isVoiceListening,
    List<ReelItem>? reels,
    int? currentReelIndex,
    bool? isVideoPlaying,
  }) {
    return ConsumerState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      currentContentTabIndex:
          currentContentTabIndex ?? this.currentContentTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isVoiceListening: isVoiceListening ?? this.isVoiceListening,
      reels: reels ?? this.reels,
      currentReelIndex: currentReelIndex ?? this.currentReelIndex,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
    );
  }

  @override
  List<Object?> get props => [
        currentNavIndex,
        currentContentTabIndex,
        isLoading,
        error,
        isVoiceListening,
        reels,
        currentReelIndex,
        isVideoPlaying,
      ];
}

// Reel item model
class ReelItem extends Equatable {
  final String id;
  final String videoUrl;
  final String username;
  final String caption;
  final int likes;
  final int comments;
  final String profileImageUrl;
  final bool isLiked;
  final bool isFollowing;

  const ReelItem({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.profileImageUrl,
    this.isLiked = false,
    this.isFollowing = false,
  });

  ReelItem copyWith({
    String? id,
    String? videoUrl,
    String? username,
    String? caption,
    int? likes,
    int? comments,
    String? profileImageUrl,
    bool? isLiked,
    bool? isFollowing,
  }) {
    return ReelItem(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      username: username ?? this.username,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  List<Object?> get props => [
        id,
        videoUrl,
        username,
        caption,
        likes,
        comments,
        profileImageUrl,
        isLiked,
        isFollowing,
      ];
}
