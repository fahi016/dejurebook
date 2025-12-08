import 'package:flutter/foundation.dart';
import 'package:dejurebook/services/gemini_service.dart';
import 'package:dejurebook/services/ai_chat_service.dart';
import 'package:dejurebook/services/supabase_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/models/ai_chat_model.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_event.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  String? _currentSessionId;

  AiChatBloc() : super(AiChatInitial()) {
    on<LoadAiChatEvent>(_onLoadAiChat);
    on<SendMessageEvent>(_onSendMessage);
    on<SendVoiceMessageEvent>(_onSendVoiceMessage);
    on<ClearChatEvent>(_onClearChat);
    on<ToggleListeningEvent>(_onToggleListening);
    on<ShowSourcesEvent>(_onShowSources);
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<DeleteChatSessionEvent>(_onDeleteChatSession);
    on<CreateNewChatEvent>(_onCreateNewChat);
  }

  Future<void> _onLoadAiChat(
      LoadAiChatEvent event, Emitter<AiChatState> emit) async {
    emit(AiChatLoading());

    try {
      // If sessionId is empty, create a new session
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        emit(AiChatError(message: 'User not authenticated'));
        return;
      }

      if (event.sessionId.isEmpty) {
        final session = await AiChatService.createSession(userId: user.id);
        _currentSessionId = session.id;
        emit(AiChatLoaded(messages: []));
        return;
      }

      final session = await AiChatService.getSession(event.sessionId);
      if (session != null) {
        _currentSessionId = session.id;
        emit(AiChatLoaded(messages: session.messages));
      } else {
        // Provided sessionId doesn't exist (e.g., placeholder) — create a real one
        final newSession = await AiChatService.createSession(userId: user.id);
        _currentSessionId = newSession.id;
        emit(AiChatLoaded(messages: []));
      }
    } catch (e) {
      emit(AiChatError(message: 'Failed to load chat: $e'));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<AiChatState> emit) async {
    if (state is AiChatLoaded) {
      final currentState = state as AiChatLoaded;
      final sessionId = event.sessionId;

      // Ensure session exists
      if (_currentSessionId == null || _currentSessionId != sessionId) {
        try {
          final user = SupabaseConfig.client.auth.currentUser;
          if (user == null) {
            emit(AiChatError(message: 'User not authenticated'));
            return;
          }

          final session = await AiChatService.createSession(
            userId: user.id,
            title: event.message.length > 30
                ? '${event.message.substring(0, 30)}...'
                : event.message,
          );
          _currentSessionId = session.id;
        } catch (e) {
          emit(AiChatError(message: 'Failed to create session: $e'));
          return;
        }
      }

      // 1️⃣ Save user message to database
      try {
        await AiChatService.saveMessage(
          sessionId: _currentSessionId!,
          content: event.message,
          isUser: true,
        );
      } catch (e) {
        debugPrint('Failed to save user message: $e');
      }

      // 2️⃣ Add the user's message and a placeholder AI message immediately
      final userMessage = AiChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      );

      final aiMessageId = "ai-${DateTime.now().millisecondsSinceEpoch}";
      final aiPlaceholder = AiChatMessage(
        id: aiMessageId,
        content: "",
        isUser: false,
        timestamp: DateTime.now(),
      );

      List<AiChatMessage> messagesWithPlaceholder = [
        ...currentState.messages,
        userMessage,
        aiPlaceholder,
      ];

      emit(currentState.copyWith(
          messages: messagesWithPlaceholder, isTyping: true));

      // 3️⃣ Start streaming response from Gemini
      final geminiService = GeminiStreamService();
      String fullResponse = "";

      try {
        await for (final chunk in geminiService.streamResponse(event.message)) {
          fullResponse += chunk;

          // Update the last AI message content in place
          final updatedList = List<AiChatMessage>.from(messagesWithPlaceholder);
          final lastIndex = updatedList.length - 1;
          updatedList[lastIndex] = AiChatMessage(
            id: aiMessageId,
            content: fullResponse,
            isUser: false,
            timestamp: DateTime.now(),
          );

          emit(currentState.copyWith(
            messages: updatedList,
            isTyping: true,
          ));

          // Keep reference for next iteration
          messagesWithPlaceholder = updatedList;
        }

        // 4️⃣ Save AI response to database
        try {
          await AiChatService.saveMessage(
            sessionId: _currentSessionId!,
            content: fullResponse,
            isUser: false,
          );
        } catch (e) {
          debugPrint('Failed to save AI message: $e');
        }

        // 5️⃣ Once streaming finishes, mark typing as false
        emit((state as AiChatLoaded).copyWith(isTyping: false));
      } catch (e) {
        emit(AiChatError(message: '⚠️ Failed to stream AI response: $e'));
      }
    }
  }

  void _onSendVoiceMessage(
      SendVoiceMessageEvent event, Emitter<AiChatState> emit) {
    // Handle voice message processing
    // This would typically involve speech-to-text conversion
    add(SendMessageEvent(
      message: "Voice message transcribed",
      sessionId: event.sessionId,
    ));
  }

  Future<void> _onClearChat(
      ClearChatEvent event, Emitter<AiChatState> emit) async {
    if (_currentSessionId != null) {
      try {
        await AiChatService.deleteSession(_currentSessionId!);
        _currentSessionId = null;
      } catch (e) {
        debugPrint('Failed to delete session: $e');
      }
    }
    emit(AiChatLoaded(messages: []));
  }

  Future<void> _onLoadChatHistory(
      LoadChatHistoryEvent event, Emitter<AiChatState> emit) async {
    emit(AiChatLoading());

    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        emit(AiChatError(message: 'User not authenticated'));
        return;
      }

      final sessions = await AiChatService.getSessions(user.id);
      emit(AiChatHistoryLoaded(sessions: sessions));
    } catch (e) {
      emit(AiChatError(message: 'Failed to load chat history: $e'));
    }
  }

  Future<void> _onDeleteChatSession(
      DeleteChatSessionEvent event, Emitter<AiChatState> emit) async {
    try {
      await AiChatService.deleteSession(event.sessionId);
      
      // Reload history if we're in history view
      if (state is AiChatHistoryLoaded) {
        final user = SupabaseConfig.client.auth.currentUser;
        if (user != null) {
          final sessions = await AiChatService.getSessions(user.id);
          emit(AiChatHistoryLoaded(sessions: sessions));
        }
      }
    } catch (e) {
      emit(AiChatError(message: 'Failed to delete chat: $e'));
    }
  }

  Future<void> _onCreateNewChat(
      CreateNewChatEvent event, Emitter<AiChatState> emit) async {
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        emit(AiChatError(message: 'User not authenticated'));
        return;
      }

      final session = await AiChatService.createSession(userId: user.id);
      _currentSessionId = session.id;
      emit(AiChatLoaded(messages: []));
    } catch (e) {
      emit(AiChatError(message: 'Failed to create new chat: $e'));
    }
  }

  void _onToggleListening(
      ToggleListeningEvent event, Emitter<AiChatState> emit) {
    if (state is AiChatLoaded) {
      final currentState = state as AiChatLoaded;
      emit(currentState.copyWith(isListening: !currentState.isListening));
    }
  }

  void _onShowSources(ShowSourcesEvent event, Emitter<AiChatState> emit) {
    // Handle showing sources for a specific message
    // This could navigate to a sources page or show a modal
  }
}
