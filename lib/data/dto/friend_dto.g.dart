// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendDtoImpl _$$FriendDtoImplFromJson(Map<String, dynamic> json) =>
    _$FriendDtoImpl(
      id: json['id'] as String,
      userAId: json['user_a_id'] as String,
      userBId: json['user_b_id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FriendDtoImplToJson(_$FriendDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_a_id': instance.userAId,
      'user_b_id': instance.userBId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
