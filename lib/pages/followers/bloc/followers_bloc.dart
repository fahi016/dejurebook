import 'package:flutter_bloc/flutter_bloc.dart';
import 'followers_event.dart';
import 'followers_state.dart';

class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  FollowersBloc() : super(const FollowersState()) {
    on<LoadFollowersEvent>(_onLoadFollowers);
    on<LoadFollowingEvent>(_onLoadFollowing);
    on<SwitchTabEvent>(_onSwitchTab);
  }

  Future<void> _onLoadFollowers(
      LoadFollowersEvent event, Emitter<FollowersState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Simulate loading followers data
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API call
    final mockFollowers = List.generate(
      5,
      (index) => UserItem(
        id: 'follower_$index',
        username: 'Username ${index + 1}',
      ),
    );

    if (!isClosed) {
      emit(state.copyWith(
        followers: mockFollowers,
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadFollowing(
      LoadFollowingEvent event, Emitter<FollowersState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Simulate loading following data
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API call
    final mockFollowing = List.generate(
      4,
      (index) => UserItem(
        id: 'following_$index',
        username: 'Username ${index + 1}',
      ),
    );

    if (!isClosed) {
      emit(state.copyWith(
        following: mockFollowing,
        isLoading: false,
      ));
    }
  }

  void _onSwitchTab(SwitchTabEvent event, Emitter<FollowersState> emit) {
    emit(state.copyWith(currentTabIndex: event.tabIndex));

    // Load data for the selected tab
    if (event.tabIndex == 0) {
      add(const LoadFollowersEvent());
    } else {
      add(const LoadFollowingEvent());
    }
  }
}
