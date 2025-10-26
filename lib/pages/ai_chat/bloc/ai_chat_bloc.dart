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

  void _onSendMessage(SendMessageEvent event, Emitter<AiChatState> emit) {
    if (state is AiChatLoaded) {
      final currentState = state as AiChatLoaded;

      // Add user message
      final userMessage = AiChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      );

      final updatedMessages = [...currentState.messages, userMessage];

      emit(currentState.copyWith(
        messages: updatedMessages,
        isTyping: true,
      ));

      // Simulate AI response after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (state is AiChatLoaded) {
          final aiMessage = AiChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: _generateAiResponse(event.message),
            isUser: false,
            timestamp: DateTime.now(),
            sources: 'Legal Database',
            suggestedActions: ['What can i do?', 'Tell me more', 'Get help'],
          );

          final finalMessages = [...updatedMessages, aiMessage];

          emit(currentState.copyWith(
            messages: finalMessages,
            isTyping: false,
          ));
        }
      });
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
