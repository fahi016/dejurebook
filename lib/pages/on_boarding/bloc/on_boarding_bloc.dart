import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_event.dart';
import 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  static const int totalPages = 3;

  OnBoardingBloc() : super(const OnBoardingState()) {
    on<PageChangedEvent>(_onPageChanged);
    on<NextPageEvent>(_onNextPage);
    on<CompleteOnBoardingEvent>(_onCompleteOnBoarding);
  }

  void _onPageChanged(
    PageChangedEvent event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.pageIndex));
  }

  void _onNextPage(
    NextPageEvent event,
    Emitter<OnBoardingState> emit,
  ) {
    if (state.currentPage < totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    } else {
      emit(state.copyWith(isCompleted: true));
    }
  }

  void _onCompleteOnBoarding(
    CompleteOnBoardingEvent event,
    Emitter<OnBoardingState> emit,
  ) {
    emit(state.copyWith(isCompleted: true));
  }
}