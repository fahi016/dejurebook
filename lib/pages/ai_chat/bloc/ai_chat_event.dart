import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadAiChatEvent extends AiChatEvent {
  final String sessionId;

  const LoadAiChatEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class SendMessageEvent extends AiChatEvent {
  final String message;
  final String sessionId;

  const SendMessageEvent({
    required this.message,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [message, sessionId];
}

class SendVoiceMessageEvent extends AiChatEvent {
  final String audioPath;
  final String sessionId;

  const SendVoiceMessageEvent({
    required this.audioPath,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [audioPath, sessionId];
}

class ClearChatEvent extends AiChatEvent {
  final String sessionId;

  const ClearChatEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class ToggleListeningEvent extends AiChatEvent {
  const ToggleListeningEvent();
}

class ShowSourcesEvent extends AiChatEvent {
  final String messageId;

  const ShowSourcesEvent({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class LoadChatHistoryEvent extends AiChatEvent {
  const LoadChatHistoryEvent();
}

class DeleteChatSessionEvent extends AiChatEvent {
  final String sessionId;

  const DeleteChatSessionEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class CreateNewChatEvent extends AiChatEvent {
  const CreateNewChatEvent();
}