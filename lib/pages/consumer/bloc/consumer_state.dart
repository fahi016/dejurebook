import 'package:equatable/equatable.dart';

class ConsumerState extends Equatable {
  final int currentNavIndex; // Bottom navigation (Home/Awaz/Reels)
  final int currentContentTabIndex; // Top tabs (deJure/News/Quires) - only on Home
  final bool isLoading;
  final String? error;

  const ConsumerState({
    this.currentNavIndex = 0,
    this.currentContentTabIndex = 0,
    this.isLoading = false,
    this.error,
  });

  ConsumerState copyWith({
    int? currentNavIndex,
    int? currentContentTabIndex,
    bool? isLoading,
    String? error,
  }) {
    return ConsumerState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      currentContentTabIndex: currentContentTabIndex ?? this.currentContentTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [currentNavIndex, currentContentTabIndex, isLoading, error];
}