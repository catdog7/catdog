// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentDtoImpl _$$CommentDtoImplFromJson(Map<String, dynamic> json) =>
    _$CommentDtoImpl(
      id: json['id'] as String,
      feedId: json['feed_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CommentDtoImplToJson(_$CommentDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'feed_id': instance.feedId,
      'user_id': instance.userId,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
