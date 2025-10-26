import 'package:equatable/equatable.dart';

class ConsumerReelsState extends Equatable {
  final List<ReelItem> reels;
  final int currentReelIndex;
  final bool isVideoPlaying;
  final bool isLoading;
  final String? error;

  const ConsumerReelsState({
    this.reels = const [],
    this.currentReelIndex = 0,
    this.isVideoPlaying = false,
    this.isLoading = false,
    this.error,
  });

  ConsumerReelsState copyWith({
    List<ReelItem>? reels,
    int? currentReelIndex,
    bool? isVideoPlaying,
    bool? isLoading,
    String? error,
  }) {
    return ConsumerReelsState(
      reels: reels ?? this.reels,
      currentReelIndex: currentReelIndex ?? this.currentReelIndex,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        reels,
        currentReelIndex,
        isVideoPlaying,
        isLoading,
        error,
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
