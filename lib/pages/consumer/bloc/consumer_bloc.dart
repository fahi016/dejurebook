import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/services/cloudinary_service.dart';
import 'consumer_event.dart';
import 'consumer_state.dart';

class ConsumerBloc extends Bloc<ConsumerEvent, ConsumerState> {
  ConsumerBloc() : super(const ConsumerState()) {
    on<ChangeNavEvent>(_onChangeNav);
    on<ChangeContentTabEvent>(_onChangeContentTab);
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<LoadAwazDataEvent>(_onLoadAwazData);
    on<LoadReelsDataEvent>(_onLoadReelsData);
    on<ToggleVoiceListeningEvent>(_onToggleVoiceListening);
    on<LikeReelEvent>(_onLikeReel);
    on<CommentReelEvent>(_onCommentReel);
    on<ShareReelEvent>(_onShareReel);
    on<FollowUserEvent>(_onFollowUser);
    on<ChangeReelEvent>(_onChangeReel);
  }

  void _onChangeNav(ChangeNavEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(currentNavIndex: event.navIndex));

    // Only load reels data if not already loaded and navigating to reels tab
    if (event.navIndex == 2 && state.reels.isEmpty) {
      add(const LoadReelsDataEvent());
    } else if (event.navIndex == 1) {
      // Awaz tab
      add(const LoadAwazDataEvent());
    }
  }

  void _onChangeContentTab(
      ChangeContentTabEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(currentContentTabIndex: event.tabIndex));
  }

  Future<void> _onLoadHomeData(
      LoadHomeDataEvent event, Emitter<ConsumerState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadAwazData(
      LoadAwazDataEvent event, Emitter<ConsumerState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadReelsData(
      LoadReelsDataEvent event, Emitter<ConsumerState> emit) async {
    // Don't reload if already loaded (unless explicitly forcing reload)
    if (state.reels.isNotEmpty && !event.forceReload) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Fetch video URLs from Cloudinary with optimized transformations
      final videoUrls = await CloudinaryService.getReelsVideoUrls();

      if (videoUrls.isEmpty) {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            error: 'No videos available',
          ));
        }
        return;
      }

      // Create ReelItem objects from Cloudinary video URLs
      final reels = videoUrls.asMap().entries.map((entry) {
        final index = entry.key;
        final videoUrl = entry.value;
        
        return ReelItem(
          id: 'reel_${index}_${DateTime.now().millisecondsSinceEpoch}',
          videoUrl: videoUrl,
          username: '@DejureBook',
          caption: 'Legal insights and knowledge for everyone',
          likes: 100 + (index * 10),
          comments: 50 + (index * 5),
          profileImageUrl: 'assets/images/profile_picture_image.png',
          isLiked: false,
          isFollowing: false,
        );
      }).toList();

      if (!isClosed) {
        emit(state.copyWith(
          reels: reels,
          isLoading: false,
          error: null,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to load reels: ${e.toString()}',
        ));
      }
    }
  }

  void _onToggleVoiceListening(
      ToggleVoiceListeningEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(isVoiceListening: !state.isVoiceListening));
  }

  void _onLikeReel(LikeReelEvent event, Emitter<ConsumerState> emit) {
    final updatedReels = state.reels.map((reel) {
      if (reel.id == event.reelId) {
        return reel.copyWith(
          isLiked: !reel.isLiked,
          likes: reel.isLiked ? reel.likes - 1 : reel.likes + 1,
        );
      }
      return reel;
    }).toList();

    emit(state.copyWith(reels: updatedReels));
  }

  void _onCommentReel(CommentReelEvent event, Emitter<ConsumerState> emit) {
    // This would typically navigate to comments screen
    emit(state);
  }

  void _onShareReel(ShareReelEvent event, Emitter<ConsumerState> emit) {
    // This would typically open share dialog
    emit(state);
  }

  void _onFollowUser(FollowUserEvent event, Emitter<ConsumerState> emit) {
    final updatedReels = state.reels.map((reel) {
      if (reel.username == event.username) {
        return reel.copyWith(isFollowing: !reel.isFollowing);
      }
      return reel;
    }).toList();

    emit(state.copyWith(reels: updatedReels));
  }

  void _onChangeReel(ChangeReelEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(currentReelIndex: event.reelIndex));
  }
}