import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _onContinue(
    ContinueEvent event,
    Emitter<UserSelectionState> emit,
  ) {
    if (state.canContinue) {
      emit(state.copyWith(isCompleted: true));
    }
  }
}