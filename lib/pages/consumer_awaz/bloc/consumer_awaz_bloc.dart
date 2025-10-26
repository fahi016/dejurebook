import 'package:flutter_bloc/flutter_bloc.dart';
import 'consumer_awaz_event.dart';
import 'consumer_awaz_state.dart';

class ConsumerAwazBloc extends Bloc<ConsumerAwazEvent, ConsumerAwazState> {
  ConsumerAwazBloc() : super(const ConsumerAwazState()) {
    on<LoadAwazDataEvent>(_onLoadAwazData);
    on<ToggleVoiceListeningEvent>(_onToggleVoiceListening);
  }

  Future<void> _onLoadAwazData(
      LoadAwazDataEvent event, Emitter<ConsumerAwazState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onToggleVoiceListening(
      ToggleVoiceListeningEvent event, Emitter<ConsumerAwazState> emit) {
    emit(state.copyWith(isVoiceListening: !state.isVoiceListening));
  }
}
