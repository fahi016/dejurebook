import 'package:flutter_bloc/flutter_bloc.dart';
import 'consumer_reels_event.dart';
import 'consumer_reels_state.dart';

class ConsumerReelsBloc extends Bloc<ConsumerReelsEvent, ConsumerReelsState> {
  ConsumerReelsBloc() : super(const ConsumerReelsState()) {
    on<LoadReelsDataEvent>(_onLoadReelsData);
    on<LikeReelEvent>(_onLikeReel);
    on<CommentReelEvent>(_onCommentReel);
    on<ShareReelEvent>(_onShareReel);
    on<FollowUserEvent>(_onFollowUser);
    on<ChangeReelEvent>(_onChangeReel);
  }

  Future<void> _onLoadReelsData(
      LoadReelsDataEvent event, Emitter<ConsumerReelsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Mock reels data
    final mockReels = List.generate(
      5,
      (index) => ReelItem(
        id: 'reel_$index',
        videoUrl: 'https://example.com/reel_$index.mp4',
        username: '@Username',
        caption: 'Hello this is how you file a case on your la...',
        likes: 100 + index * 10,
        comments: 79,
        profileImageUrl: 'assets/images/profile_picture_image.png',
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (!isClosed) {
      emit(state.copyWith(
        reels: mockReels,
        isLoading: false,
      ));
    }
  }

  void _onLikeReel(LikeReelEvent event, Emitter<ConsumerReelsState> emit) {
    final updatedReels = state.reels.map((reel) {
      if (reel.id == event.reelId) {
        return ReelItem(
          id: reel.id,
          videoUrl: reel.videoUrl,
          username: reel.username,
          caption: reel.caption,
          likes: reel.likes + 1,
          comments: reel.comments,
          profileImageUrl: reel.profileImageUrl,
        );
      }
      return reel;
    }).toList();

    emit(state.copyWith(reels: updatedReels));
  }

  void _onCommentReel(
      CommentReelEvent event, Emitter<ConsumerReelsState> emit) {
    // This would typically navigate to comments screen
    emit(state);
  }

  void _onShareReel(ShareReelEvent event, Emitter<ConsumerReelsState> emit) {
    // This would typically open share dialog
    emit(state);
  }

  void _onFollowUser(FollowUserEvent event, Emitter<ConsumerReelsState> emit) {
    // This would update the user's following list
    emit(state);
  }

  void _onChangeReel(ChangeReelEvent event, Emitter<ConsumerReelsState> emit) {
    emit(state.copyWith(currentReelIndex: event.reelIndex));
  }
}
