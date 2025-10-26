import 'package:flutter_bloc/flutter_bloc.dart';
import 'consumer_home_event.dart';
import 'consumer_home_state.dart';

class ConsumerHomeBloc extends Bloc<ConsumerHomeEvent, ConsumerHomeState> {
  ConsumerHomeBloc() : super(const ConsumerHomeState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<ChangeContentTabEvent>(_onChangeContentTab);
  }

  Future<void> _onLoadHomeData(
      LoadHomeDataEvent event, Emitter<ConsumerHomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await Future.delayed(const Duration(seconds: 1));
    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onChangeContentTab(
      ChangeContentTabEvent event, Emitter<ConsumerHomeState> emit) {
    emit(state.copyWith(currentContentTabIndex: event.tabIndex));
  }
}
