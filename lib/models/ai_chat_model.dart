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
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['is_user'] as bool? ?? json['isUser'] as bool? ?? false,
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['timestamp'] != null
              ? DateTime.parse(json['timestamp'] as String)
              : DateTime.now(),
      sources: json['sources'] as String?,
      suggestedActions: json['suggested_actions'] != null
          ? List<String>.from(json['suggested_actions'] as List)
          : json['suggestedActions'] != null
              ? List<String>.from(json['suggestedActions'] as List)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user': isUser,
      'isUser': isUser, // Keep both for backward compatibility
      'created_at': timestamp.toIso8601String(),
      'timestamp': timestamp.toIso8601String(), // Keep both for backward compatibility
      'sources': sources,
      'suggested_actions': suggestedActions,
      'suggestedActions': suggestedActions, // Keep both for backward compatibility
    };
  }
}

class AiChatSession {
  final String id;
  final String userId;
  final String title;
  final List<AiChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  AiChatSession({
    required this.id,
    required this.userId,
    required this.title,
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiChatSession.fromJson(Map<String, dynamic> json) {
    return AiChatSession(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((msg) => AiChatMessage.fromJson(msg))
              .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(), // Keep both for backward compatibility
      'updated_at': updatedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(), // Keep both for backward compatibility
    };
  }

  AiChatSession copyWith({
    String? id,
    String? userId,
    String? title,
    List<AiChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AiChatSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
