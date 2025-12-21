// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_like_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedLikeDtoImpl _$$FeedLikeDtoImplFromJson(Map<String, dynamic> json) =>
    _$FeedLikeDtoImpl(
      id: json['id'] as String,
      feedId: json['feed_id'] as String,
      userId: json['user_id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FeedLikeDtoImplToJson(_$FeedLikeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'feed_id': instance.feedId,
      'user_id': instance.userId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
