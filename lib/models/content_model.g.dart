// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      videoUrl: json['videoUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      documentUrl: json['documentUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      category: json['category'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: $enumDecode(_$PostStatusEnumMap, json['status']),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'title': instance.title,
      'content': instance.content,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'imageUrls': instance.imageUrls,
      'videoUrl': instance.videoUrl,
      'audioUrl': instance.audioUrl,
      'documentUrl': instance.documentUrl,
      'tags': instance.tags,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': _$PostStatusEnumMap[instance.status]!,
      'likes': instance.likes,
      'comments': instance.comments,
      'shares': instance.shares,
      'views': instance.views,
      'isLiked': instance.isLiked,
      'isBookmarked': instance.isBookmarked,
      'metadata': instance.metadata,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.image: 'image',
  ContentType.video: 'video',
  ContentType.audio: 'audio',
  ContentType.document: 'document',
  ContentType.poll: 'poll',
  ContentType.event: 'event',
};

const _$PostStatusEnumMap = {
  PostStatus.draft: 'draft',
  PostStatus.published: 'published',
  PostStatus.archived: 'archived',
  PostStatus.deleted: 'deleted',
};

Reel _$ReelFromJson(Map<String, dynamic> json) => Reel(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      caption: json['caption'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: $enumDecode(_$ReelStatusEnumMap, json['status']),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ReelToJson(Reel instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'caption': instance.caption,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'duration': instance.duration.inMicroseconds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': _$ReelStatusEnumMap[instance.status]!,
      'likes': instance.likes,
      'comments': instance.comments,
      'shares': instance.shares,
      'views': instance.views,
      'isLiked': instance.isLiked,
      'hashtags': instance.hashtags,
      'location': instance.location,
      'metadata': instance.metadata,
    };

const _$ReelStatusEnumMap = {
  ReelStatus.processing: 'processing',
  ReelStatus.published: 'published',
  ReelStatus.archived: 'archived',
  ReelStatus.deleted: 'deleted',
};

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      parentCommentId: json['parentCommentId'] as String?,
      replies:
          (json['replies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: $enumDecodeNullable(_$CommentStatusEnumMap, json['status']) ??
          CommentStatus.active,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'parentCommentId': instance.parentCommentId,
      'replies': instance.replies,
      'status': _$CommentStatusEnumMap[instance.status]!,
    };

const _$CommentStatusEnumMap = {
  CommentStatus.active: 'active',
  CommentStatus.hidden: 'hidden',
  CommentStatus.deleted: 'deleted',
};
