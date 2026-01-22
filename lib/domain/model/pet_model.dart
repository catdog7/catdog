import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_model.freezed.dart';

@freezed
class PetModel with _$PetModel {
  const factory PetModel({
    required String id,
    required String userId,
    required String name,
    required String species,
    DateTime? birthDate,
    required String birthDatePrecision,
    String? image2dUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PetModel;
}
