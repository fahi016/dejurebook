import 'package:dejurebook/services/gemini_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/models/ai_chat_model.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_event.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc() : super(AiChatInitial()) {
    on<LoadAiChatEvent>(_onLoadAiChat);
    on<SendMessageEvent>(_onSendMessage);
    on<SendVoiceMessageEvent>(_onSendVoiceMessage);
    on<ClearChatEvent>(_onClearChat);
    on<ToggleListeningEvent>(_onToggleListening);
    on<ShowSourcesEvent>(_onShowSources);
  }

  void _onLoadAiChat(LoadAiChatEvent event, Emitter<AiChatState> emit) {
    emit(AiChatLoading());

    // Simulate loading initial messages
    final initialMessages = [
      AiChatMessage(
        id: '1',
        content: 'My boss just harassed me. Is this illegal?',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AiChatMessage(
        id: '2',
        content:
            'Yes, workplace harassment is illegal under Indian law. You are protected by the Sexual Harassment of Women at Workplace (Prevention, Prohibition and Redressal) Act, 2013, and the Indian Penal Code in some cases.\n\nYou can:\n1. File a written complaint with your company\'s Internal Complaints Committee (ICC) — every company with more than 10 employees is required to have one.\n2. If no ICC exists or you don\'t feel safe, you can approach the Local Complaints Committee (LCC) in your district.\n3. You may also file a police complaint if the harassment is severe.\n\nWould you like to learn the step-by-step process or get connected to a legal advisor?\n\nLet me know if you want versions for:\n• Mild harassment (verbal, messages)\n• Male/female/other victims\n• Anonymous reporting or evidence-gathering advice.',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        sources: 'Sexual Harassment of Women at Workplace Act, 2013',
        suggestedActions: ['What can i do?'],
      ),
    ];

    emit(AiChatLoaded(messages: initialMessages));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<AiChatState> emit) async {
    if (state is AiChatLoaded) {
      final currentState = state as AiChatLoaded;

      // 1️⃣ Add the user's message and a placeholder AI message immediately
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

      // 2️⃣ Start streaming response from Gemini
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

        // 3️⃣ Once streaming finishes, mark typing as false
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

  void _onClearChat(ClearChatEvent event, Emitter<AiChatState> emit) {
    emit(AiChatLoaded(messages: []));
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

  String _generateAiResponse(String userMessage) {
    // Simple AI response generation based on keywords
    final message = userMessage.toLowerCase();

    if (message.contains('harassment') || message.contains('harassed')) {
      return 'Workplace harassment is a serious issue. You have several legal protections and options available. Let me help you understand your rights and the steps you can take.';
    } else if (message.contains('rights') || message.contains('legal')) {
      return 'Your legal rights include protection from harassment, discrimination, and unfair treatment. I can provide specific guidance based on your situation.';
    } else if (message.contains('complaint') || message.contains('file')) {
      return 'Filing a complaint involves several steps. I can guide you through the process, including documentation requirements and where to submit your complaint.';
    } else {
      return 'I understand you need legal assistance. Please provide more details about your situation so I can offer the most relevant guidance and support.';
    }
  }
}
