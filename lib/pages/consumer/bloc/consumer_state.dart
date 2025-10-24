import 'package:equatable/equatable.dart';

class ConsumerState extends Equatable {
  final int currentNavIndex; // Bottom navigation (Home/Awaz/Reels)
  final int
      currentContentTabIndex; // Top tabs (deJure/News/Quires) - only on Home
  final bool isLoading;
  final String? error;
  final bool isVoiceListening; // For Awaz voice listening state

  const ConsumerState({
    this.currentNavIndex = 0,
    this.currentContentTabIndex = 0,
    this.isLoading = false,
    this.error,
    this.isVoiceListening = false,
  });

  ConsumerState copyWith({
    int? currentNavIndex,
    int? currentContentTabIndex,
    bool? isLoading,
    String? error,
    bool? isVoiceListening,
  }) {
    return ConsumerState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
      currentContentTabIndex:
          currentContentTabIndex ?? this.currentContentTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isVoiceListening: isVoiceListening ?? this.isVoiceListening,
    );
  }

  @override
  List<Object?> get props => [
        currentNavIndex,
        currentContentTabIndex,
        isLoading,
        error,
        isVoiceListening
      ];
}
