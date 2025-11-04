import 'package:equatable/equatable.dart';

class OnBoardingState extends Equatable {
  final int currentPage;
  final bool isCompleted;

  const OnBoardingState({
    this.currentPage = 0,
    this.isCompleted = false,
  });

  OnBoardingState copyWith({
    int? currentPage,
    bool? isCompleted,
  }) {
    return OnBoardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [currentPage, isCompleted];
}
