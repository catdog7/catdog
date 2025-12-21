// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedDtoImpl _$$FeedDtoImplFromJson(Map<String, dynamic> json) =>
    _$FeedDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      content: json['content'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FeedDtoImplToJson(_$FeedDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'image_url': instance.imageUrl,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
