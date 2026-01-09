// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentLikeDtoImpl _$$CommentLikeDtoImplFromJson(Map<String, dynamic> json) =>
    _$CommentLikeDtoImpl(
      id: json['id'] as String,
      commentId: json['comment_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CommentLikeDtoImplToJson(
  _$CommentLikeDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'comment_id': instance.commentId,
  'user_id': instance.userId,
  'created_at': instance.createdAt.toIso8601String(),
};
