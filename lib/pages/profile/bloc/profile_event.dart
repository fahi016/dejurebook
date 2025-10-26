import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileDataEvent extends ProfileEvent {
  const LoadProfileDataEvent();
}

class FollowUserEvent extends ProfileEvent {
  const FollowUserEvent();
}

class UnfollowUserEvent extends ProfileEvent {
  const UnfollowUserEvent();
}

class SendMessageEvent extends ProfileEvent {
  const SendMessageEvent();
}

class BecomeCreatorEvent extends ProfileEvent {
  const BecomeCreatorEvent();
}
