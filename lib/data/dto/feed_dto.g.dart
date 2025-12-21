// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedDtoImpl _$$FeedDtoImplFromJson(Map<String, dynamic> json) =>
    _$FeedDtoImpl(
      writerId: json['writer_id'] as String,
      nickname: json['nickname'] as String,
      tag: (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
      content: json['content'] as String,
      imageUrl: json['image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      modifiedAt: DateTime.parse(json['modified_at'] as String),
    );

Map<String, dynamic> _$$FeedDtoImplToJson(_$FeedDtoImpl instance) =>
    <String, dynamic>{
      'writer_id': instance.writerId,
      'nickname': instance.nickname,
      'tag': instance.tag,
      'content': instance.content,
      'image_url': instance.imageUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'modified_at': instance.modifiedAt.toIso8601String(),
    };
