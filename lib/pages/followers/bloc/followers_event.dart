import 'package:equatable/equatable.dart';

abstract class FollowersEvent extends Equatable {
  const FollowersEvent();

  @override
  List<Object> get props => [];
}

class LoadFollowersEvent extends FollowersEvent {
  const LoadFollowersEvent();
}

class LoadFollowingEvent extends FollowersEvent {
  const LoadFollowingEvent();
}

class SwitchTabEvent extends FollowersEvent {
  final int tabIndex;

  const SwitchTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
