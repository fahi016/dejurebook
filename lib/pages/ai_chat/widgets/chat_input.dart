import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isListening;
  final VoidCallback onToggleListening;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isListening,
    required this.onToggleListening,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D3D3D),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: 'Ask follow-up...',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF8E8E93),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 5,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    // Send button inside input
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 6,
                        bottom: 6,
                      ),
                      child: GestureDetector(
                        onTap: widget.controller.text.trim().isNotEmpty
                            ? widget.onSend
                            : null,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: widget.controller.text.trim().isNotEmpty
                                ? Colors.white
                                : Colors.grey[600],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: widget.controller.text.trim().isNotEmpty
                                ? Colors.black
                                : Colors.grey[400],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}