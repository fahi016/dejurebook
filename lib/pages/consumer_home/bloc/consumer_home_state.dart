import 'package:equatable/equatable.dart';

class ConsumerHomeState extends Equatable {
  final int currentContentTabIndex; // Top tabs (deJure/News/Quires)
  final bool isLoading;
  final String? error;

  const ConsumerHomeState({
    this.currentContentTabIndex = 0,
    this.isLoading = false,
    this.error,
  });

  ConsumerHomeState copyWith({
    int? currentContentTabIndex,
    bool? isLoading,
    String? error,
  }) {
    return ConsumerHomeState(
      currentContentTabIndex:
          currentContentTabIndex ?? this.currentContentTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        currentContentTabIndex,
        isLoading,
        error,
      ];
}
