import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfileDataEvent>(_onLoadProfileData);
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<SendMessageEvent>(_onSendMessage);
    on<BecomeCreatorEvent>(_onBecomeCreator);
  }

  Future<void> _onLoadProfileData(
      LoadProfileDataEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Simulate loading profile data
    await Future.delayed(const Duration(milliseconds: 500));

    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onFollowUser(FollowUserEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      isFollowing: true,
      followersCount: state.followersCount + 1,
    ));
  }

  void _onUnfollowUser(UnfollowUserEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      isFollowing: false,
      followersCount: state.followersCount - 1,
    ));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ProfileState> emit) {
    // This would typically navigate to messages screen
    // For now, we'll just emit the same state
    emit(state);
  }

  void _onBecomeCreator(BecomeCreatorEvent event, Emitter<ProfileState> emit) {
    // This would typically navigate to creator registration screen
    // For now, we'll just emit the same state
    emit(state);
  }
}
