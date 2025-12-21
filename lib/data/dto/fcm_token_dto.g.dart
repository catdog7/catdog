// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FcmTokenDtoImpl _$$FcmTokenDtoImplFromJson(Map<String, dynamic> json) =>
    _$FcmTokenDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      token: json['token'] as String,
      platform: json['platform'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FcmTokenDtoImplToJson(_$FcmTokenDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'token': instance.token,
      'platform': instance.platform,
      'created_at': instance.createdAt?.toIso8601String(),
    };
