// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isDelivered: json['isDelivered'] as bool? ?? false,
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentType: json['attachmentType'] as String?,
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      replyToMessageId: json['replyToMessageId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'isDelivered': instance.isDelivered,
      'attachmentUrl': instance.attachmentUrl,
      'attachmentType': instance.attachmentType,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'replyToMessageId': instance.replyToMessageId,
      'metadata': instance.metadata,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
  MessageType.document: 'document',
  MessageType.location: 'location',
  MessageType.contact: 'contact',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessageId: json['lastMessageId'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      createdById: json['createdById'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'participantIds': instance.participantIds,
      'lastMessageId': instance.lastMessageId,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'createdById': instance.createdById,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'settings': instance.settings,
      'isActive': instance.isActive,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.direct: 'direct',
  ConversationType.group: 'group',
  ConversationType.channel: 'channel',
};
