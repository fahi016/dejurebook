import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'user_selection_event.dart';
import 'user_selection_state.dart';

class UserSelectionBloc extends Bloc<UserSelectionEvent, UserSelectionState> {
  UserSelectionBloc() : super(const UserSelectionState()) {
    on<SelectUserTypeEvent>(_onSelectUserType);
    on<ContinueEvent>(_onContinue);
  }

  void _onSelectUserType(
    SelectUserTypeEvent event,
    Emitter<UserSelectionState> emit,
  ) {
    emit(state.copyWith(selectedUserType: event.userType));
  }

  Future<void> _onContinue(
    ContinueEvent event,
    Emitter<UserSelectionState> emit,
  ) async {
    if (state.canContinue) {
      try {
        // Save user type to profile
        final userTypeString =
            _convertUserTypeToString(state.selectedUserType!);

        print('Updating user type to: $userTypeString');
        await ProfileService.updateCurrentUserProfile(
          userType: userTypeString,
        );
        print('User type updated successfully');

        emit(state.copyWith(isCompleted: true));
      } catch (e) {
        print('Error updating user type: $e');
        // Handle error - user type save failed but continue anyway
        emit(state.copyWith(isCompleted: true));
      }
    }
  }

  String _convertUserTypeToString(UserType userType) {
    switch (userType) {
      case UserType.consumer:
        return 'consumer';
      case UserType.lawyer:
        return 'lawyer';
      case UserType.lawStudent:
        return 'law_student';
      case UserType.other:
        return 'other';
    }
  }
}
