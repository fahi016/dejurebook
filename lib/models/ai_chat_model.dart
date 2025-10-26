class AiChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? sources;
  final List<String>? suggestedActions;

  AiChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.sources,
    this.suggestedActions,
  });

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      sources: json['sources'],
      suggestedActions: json['suggestedActions'] != null
          ? List<String>.from(json['suggestedActions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'sources': sources,
      'suggestedActions': suggestedActions,
    };
  }
}

class AiChatSession {
  final String id;
  final String title;
  final List<AiChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  AiChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiChatSession.fromJson(Map<String, dynamic> json) {
    return AiChatSession(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((msg) => AiChatMessage.fromJson(msg))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
