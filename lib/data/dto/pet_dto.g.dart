// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetDtoImpl _$$PetDtoImplFromJson(Map<String, dynamic> json) => _$PetDtoImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  species: json['species'] as String,
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
  birthDatePrecision: json['birth_date_precision'] as String,
  image2dUrl: json['image_2d_url'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$PetDtoImplToJson(_$PetDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'species': instance.species,
      'birth_date': instance.birthDate?.toIso8601String(),
      'birth_date_precision': instance.birthDatePrecision,
      'image_2d_url': instance.image2dUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
