import 'package:equatable/equatable.dart';
import 'package:dejurebook/models/ai_chat_model.dart';

abstract class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object?> get props => [];
}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {}

class AiChatLoaded extends AiChatState {
  final List<AiChatMessage> messages;
  final bool isListening;
  final bool isTyping;

  const AiChatLoaded({
    required this.messages,
    this.isListening = false,
    this.isTyping = false,
  });

  @override
  List<Object?> get props => [messages, isListening, isTyping];

  AiChatLoaded copyWith({
    List<AiChatMessage>? messages,
    bool? isListening,
    bool? isTyping,
  }) {
    return AiChatLoaded(
      messages: messages ?? this.messages,
      isListening: isListening ?? this.isListening,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class AiChatError extends AiChatState {
  final String message;

  const AiChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AiChatHistoryLoaded extends AiChatState {
  final List<AiChatSession> sessions;

  const AiChatHistoryLoaded({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}