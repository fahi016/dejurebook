import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_bloc.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_event.dart';
import 'package:dejurebook/pages/ai_chat/bloc/ai_chat_state.dart';
import 'package:dejurebook/pages/ai_chat/widgets/chat_bubble.dart';
import 'package:dejurebook/pages/ai_chat/widgets/chat_input.dart';

class AiChatPage extends StatefulWidget {
  final String sessionId;

  const AiChatPage({
    super.key,
    required this.sessionId,
  });

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context
        .read<AiChatBloc>()
        .add(LoadAiChatEvent(sessionId: widget.sessionId));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      context.read<AiChatBloc>().add(
            SendMessageEvent(
              message: _textController.text.trim(),
              sessionId: widget.sessionId,
            ),
          );
      _textController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<AiChatBloc, AiChatState>(
        listener: (context, state) {
          if (state is AiChatLoaded) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is AiChatLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if (state is AiChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is AiChatLoaded) {
            return Column(
              children: [
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.messages.length) {
                        final message = state.messages[index];
                        return ChatBubble(
                          message: message,
                          onSourcesTap: () {
                            context.read<AiChatBloc>().add(
                                  ShowSourcesEvent(messageId: message.id),
                                );
                          },
                          onSuggestedActionTap: (action) {
                            _textController.text = action;
                            _sendMessage();
                          },
                        );
                      } else {
                        // Typing indicator
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'AI is typing...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),

                // Chat input
                ChatInput(
                  controller: _textController,
                  onSend: _sendMessage,
                  isListening: state.isListening,
                  onToggleListening: () {
                    context
                        .read<AiChatBloc>()
                        .add(const ToggleListeningEvent());
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
