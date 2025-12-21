// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_dto.freezed.dart';
part 'pet_dto.g.dart';

@freezed
class PetDto with _$PetDto {
  const factory PetDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String species,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'birth_date_precision') required String birthDatePrecision,
    @JsonKey(name: 'image_2d_url') String? image2dUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PetDto;

  factory PetDto.fromJson(Map<String, dynamic> json) => _$PetDtoFromJson(json);
}
