import 'package:equatable/equatable.dart';

class ConsumerAwazState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool isVoiceListening;

  const ConsumerAwazState({
    this.isLoading = false,
    this.error,
    this.isVoiceListening = false,
  });

  ConsumerAwazState copyWith({
    bool? isLoading,
    String? error,
    bool? isVoiceListening,
  }) {
    return ConsumerAwazState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isVoiceListening: isVoiceListening ?? this.isVoiceListening,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        isVoiceListening,
      ];
}
