import 'package:equatable/equatable.dart';

abstract class ConsumerAwazEvent extends Equatable {
  const ConsumerAwazEvent();

  @override
  List<Object> get props => [];
}

class LoadAwazDataEvent extends ConsumerAwazEvent {
  const LoadAwazDataEvent();
}

class ToggleVoiceListeningEvent extends ConsumerAwazEvent {
  const ToggleVoiceListeningEvent();
}
