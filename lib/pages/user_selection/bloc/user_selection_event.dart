import 'package:equatable/equatable.dart';

enum UserType { consumer, lawyer, lawStudent, other }

abstract class UserSelectionEvent extends Equatable {
  const UserSelectionEvent();

  @override
  List<Object> get props => [];
}

class SelectUserTypeEvent extends UserSelectionEvent {
  final UserType userType;

  const SelectUserTypeEvent(this.userType);

  @override
  List<Object> get props => [userType];
}

class ContinueEvent extends UserSelectionEvent {
  const ContinueEvent();
}