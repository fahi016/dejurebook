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

  const ReelItem({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        videoUrl,
        username,
        caption,
        likes,
        comments,
        profileImageUrl,
      ];
}
