import 'package:flutter/material.dart';
import 'package:dejurebook/models/message_model.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(message.imagePath),
        radius: 24,
      ),
      title: Text(
        message.username,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        message.message,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
