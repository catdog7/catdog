import 'package:catdog/data/dto/pet_dto.dart';
import 'package:catdog/data/mapper/pet_mapper.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/domain/repository/pet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> addPet(PetModel pet) async {
    final dto = PetMapper.toDto(pet);
    await client.from('pets').insert(dto.toJson());
  }

  @override
  Future<List<PetModel>> getPets(String userId) async {
    final data = await client.from('pets').select().eq('user_id', userId);
    return (data as List).map((e) => PetMapper.toDomain(PetDto.fromJson(e))).toList();
  }

  @override
  Future<void> updatePet(PetModel pet) async {
    final dto = PetMapper.toDto(pet);
    await client.from('pets').update(dto.toJson()).eq('id', pet.id);
  }

  @override
  Future<void> deletePet(String petId) async {
    await client.from('pets').delete().eq('id', petId);
  }
}
