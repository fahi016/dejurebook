import 'package:equatable/equatable.dart';

abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object> get props => [];
}

class PageChangedEvent extends OnBoardingEvent {
  final int pageIndex;

  const PageChangedEvent(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

class NextPageEvent extends OnBoardingEvent {
  const NextPageEvent();
}

class CompleteOnBoardingEvent extends OnBoardingEvent {
  const CompleteOnBoardingEvent();
}