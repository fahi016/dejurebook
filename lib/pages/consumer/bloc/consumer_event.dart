import 'package:equatable/equatable.dart';

abstract class ConsumerEvent extends Equatable {
  const ConsumerEvent();

  @override
  List<Object> get props => [];
}

class ChangeNavEvent extends ConsumerEvent {
  final int navIndex;

  const ChangeNavEvent(this.navIndex);

  @override
  List<Object> get props => [navIndex];
}

class ChangeContentTabEvent extends ConsumerEvent {
  final int tabIndex;

  const ChangeContentTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class LoadHomeDataEvent extends ConsumerEvent {
  const LoadHomeDataEvent();
}

class LoadAwazDataEvent extends ConsumerEvent {
  const LoadAwazDataEvent();
}

class LoadReelsDataEvent extends ConsumerEvent {
  const LoadReelsDataEvent();
}

class ToggleVoiceListeningEvent extends ConsumerEvent {
  const ToggleVoiceListeningEvent();
}

class LikeReelEvent extends ConsumerEvent {
  final String reelId;

  const LikeReelEvent(this.reelId);

  @override
  List<Object> get props => [reelId];
}

class CommentReelEvent extends ConsumerEvent {
  final String reelId;

  const CommentReelEvent(this.reelId);

  @override
  List<Object> get props => [reelId];
}

class ShareReelEvent extends ConsumerEvent {
  final String reelId;

  const ShareReelEvent(this.reelId);

  @override
  List<Object> get props => [reelId];
}

class FollowUserEvent extends ConsumerEvent {
  final String username;

  const FollowUserEvent(this.username);

  @override
  List<Object> get props => [username];
}

class ChangeReelEvent extends ConsumerEvent {
  final int reelIndex;

  const ChangeReelEvent(this.reelIndex);

  @override
  List<Object> get props => [reelIndex];
}
