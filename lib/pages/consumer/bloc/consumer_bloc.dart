import 'package:flutter_bloc/flutter_bloc.dart';
import 'consumer_event.dart';
import 'consumer_state.dart';

class ConsumerBloc extends Bloc<ConsumerEvent, ConsumerState> {
  ConsumerBloc() : super(const ConsumerState()) {
    on<ChangeNavEvent>(_onChangeNav);
    on<ChangeContentTabEvent>(_onChangeContentTab);
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<LoadAwazDataEvent>(_onLoadAwazData);
    on<LoadReelsDataEvent>(_onLoadReelsData);
  }

  void _onChangeNav(ChangeNavEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(currentNavIndex: event.navIndex));
  }

  void _onChangeContentTab(ChangeContentTabEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(currentContentTabIndex: event.tabIndex));
  }

  void _onLoadHomeData(LoadHomeDataEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(isLoading: true, error: null));
    
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  void _onLoadAwazData(LoadAwazDataEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(isLoading: true, error: null));
    
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  void _onLoadReelsData(LoadReelsDataEvent event, Emitter<ConsumerState> emit) {
    emit(state.copyWith(isLoading: true, error: null));
    
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}