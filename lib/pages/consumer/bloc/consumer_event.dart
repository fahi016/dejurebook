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