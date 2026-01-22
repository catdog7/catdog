// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowRequestDtoImpl _$$FollowRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$FollowRequestDtoImpl(
  id: json['id'] as String,
  fromUserId: json['from_user_id'] as String,
  toUserId: json['to_user_id'] as String,
  status: json['status'] as String? ?? 'PENDING',
  type: json['type'] as String? ?? 'FRIEND',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$FollowRequestDtoImplToJson(
  _$FollowRequestDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'from_user_id': instance.fromUserId,
  'to_user_id': instance.toUserId,
  'status': instance.status,
  'type': instance.type,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
