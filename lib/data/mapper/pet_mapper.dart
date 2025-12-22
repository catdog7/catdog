import 'package:catdog/data/dto/pet_dto.dart';
import 'package:catdog/domain/model/pet_model.dart';

class PetMapper {
  static PetModel toModel(PetDto dto) => PetModel(
        id: dto.id,
        userId: dto.userId,
        name: dto.name,
        species: dto.species,
        birthDate: dto.birthDate,
        birthDatePrecision: dto.birthDatePrecision,
        image2dUrl: dto.image2dUrl,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );

  static PetDto toDto(PetModel model) => PetDto(
        id: model.id,
        userId: model.userId,
        name: model.name,
        species: model.species,
        birthDate: model.birthDate,
        birthDatePrecision: model.birthDatePrecision,
        image2dUrl: model.image2dUrl,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );
}
