import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dejurebook/models/ai_chat_model.dart';
import 'package:dejurebook/services/supabase_config.dart';

class AiChatService {
  static final SupabaseClient _supabase = SupabaseConfig.client;
  static const String _sessionsTable = 'ai_chat_sessions';
  static const String _messagesTable = 'ai_chat_messages';

  // Create a new chat session
  static Future<AiChatSession> createSession({
    required String userId,
    String? title,
  }) async {
    try {
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now().toIso8601String();

      final response = await _supabase
          .from(_sessionsTable)
          .insert({
            'id': sessionId,
            'user_id': userId,
            'title': title ?? 'New Chat',
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      return AiChatSession(
        id: response['id'] as String,
        userId: userId,
        title: response['title'] as String,
        createdAt: DateTime.parse(response['created_at'] as String),
        updatedAt: DateTime.parse(response['updated_at'] as String),
      );
    } catch (e) {
      throw Exception('Failed to create chat session: $e');
    }
  }

  // Get all chat sessions for a user
  static Future<List<AiChatSession>> getSessions(String userId) async {
    try {
      final response = await _supabase
          .from(_sessionsTable)
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List)
          .map((json) => AiChatSession.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch chat sessions: $e');
    }
  }

  // Get a single chat session with messages
  static Future<AiChatSession?> getSession(String sessionId) async {
    try {
      final sessionResponse = await _supabase
          .from(_sessionsTable)
          .select()
          .eq('id', sessionId)
          .maybeSingle();

      if (sessionResponse == null) return null;

      final messagesResponse = await _supabase
          .from(_messagesTable)
          .select()
          .eq('session_id', sessionId)
          .order('created_at', ascending: true);

      final messages = (messagesResponse as List)
          .map((json) => AiChatMessage.fromJson(json))
          .toList();

      return AiChatSession.fromJson(sessionResponse).copyWith(
        messages: messages,
      );
    } catch (e) {
      throw Exception('Failed to fetch chat session: $e');
    }
  }

  // Save a message to the database
  static Future<AiChatMessage> saveMessage({
    required String sessionId,
    required String content,
    required bool isUser,
    String? sources,
    List<String>? suggestedActions,
  }) async {
    try {
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now().toIso8601String();

      await _supabase.from(_messagesTable).insert({
        'id': messageId,
        'session_id': sessionId,
        'content': content,
        'is_user': isUser,
        'sources': sources,
        'suggested_actions': suggestedActions,
        'created_at': now,
      });

      // Update session's updated_at
      await _supabase
          .from(_sessionsTable)
          .update({'updated_at': now})
          .eq('id', sessionId);

      return AiChatMessage(
        id: messageId,
        content: content,
        isUser: isUser,
        timestamp: DateTime.parse(now),
        sources: sources,
        suggestedActions: suggestedActions,
      );
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  // Update session title
  static Future<void> updateSessionTitle({
    required String sessionId,
    required String title,
  }) async {
    try {
      await _supabase
          .from(_sessionsTable)
          .update({
            'title': title,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId);
    } catch (e) {
      throw Exception('Failed to update session title: $e');
    }
  }

  // Delete a chat session (and all its messages)
  static Future<void> deleteSession(String sessionId) async {
    try {
      // Delete all messages first
      await _supabase
          .from(_messagesTable)
          .delete()
          .eq('session_id', sessionId);

      // Delete the session
      await _supabase
          .from(_sessionsTable)
          .delete()
          .eq('id', sessionId);
    } catch (e) {
      throw Exception('Failed to delete chat session: $e');
    }
  }

  // Delete a single message
  static Future<void> deleteMessage(String messageId) async {
    try {
      await _supabase
          .from(_messagesTable)
          .delete()
          .eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}

