import 'package:equatable/equatable.dart';
import 'user_selection_event.dart';

class UserSelectionState extends Equatable {
  final UserType? selectedUserType;
  final bool isCompleted;

  const UserSelectionState({
    this.selectedUserType,
    this.isCompleted = false,
  });

  bool get canContinue => selectedUserType != null;

  UserSelectionState copyWith({
    UserType? selectedUserType,
    bool? isCompleted,
  }) {
    return UserSelectionState(
      selectedUserType: selectedUserType ?? this.selectedUserType,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [selectedUserType, isCompleted];
}