import 'package:equatable/equatable.dart';

abstract class ConsumerReelsEvent extends Equatable {
  const ConsumerReelsEvent();

  @override
  List<Object> get props => [];
}

class LoadReelsDataEvent extends ConsumerReelsEvent {
  const LoadReelsDataEvent();
}

class LikeReelEvent extends ConsumerReelsEvent {
  final String reelId;

  const LikeReelEvent(this.reelId);

  @override
  List<Object> get props => [reelId];
}

class CommentReelEvent extends ConsumerReelsEvent {
  final String reelId;

  const CommentReelEvent(this.reelId);

  @override
  List<Object> get props => [reelId];
}

class ShareReelEvent extends ConsumerReelsEvent {
  final String reelId;

  const ShareReelEvent(this.reelId);

  @override
  List<Object> get props => [reelId];
}

class FollowUserEvent extends ConsumerReelsEvent {
  final String username;

  const FollowUserEvent(this.username);

  @override
  List<Object> get props => [username];
}

class ChangeReelEvent extends ConsumerReelsEvent {
  final int reelIndex;

  const ChangeReelEvent(this.reelIndex);

  @override
  List<Object> get props => [reelIndex];
}
