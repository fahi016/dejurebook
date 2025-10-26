import 'package:equatable/equatable.dart';

abstract class ConsumerHomeEvent extends Equatable {
  const ConsumerHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeDataEvent extends ConsumerHomeEvent {
  const LoadHomeDataEvent();
}

class ChangeContentTabEvent extends ConsumerHomeEvent {
  final int tabIndex;

  const ChangeContentTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
