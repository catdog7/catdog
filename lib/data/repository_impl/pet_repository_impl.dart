import 'package:catdog/data/dto/pet_dto.dart';
import 'package:catdog/data/mapper/pet_mapper.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/domain/repository/pet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetRepositoryImpl implements PetRepository {
  final SupabaseClient _client;

  PetRepositoryImpl(this._client);

  @override
  Future<List<PetModel>> getPets(String userId) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('user_id', userId);
    
    return response
        .map((json) => PetMapper.toModel(PetDto.fromJson(json)))
        .toList();
  }

  @override
  Future<bool> hasPets(String userId) async {
    try {
      // limit 1로 최소한의 데이터만 조회하여 효율성 향상
      final response = await _client
          .from('pets')
          .select('id')
          .eq('user_id', userId)
          .limit(1)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('hasPets error: $e');
      return false;
    }
  }

  @override
  Future<void> addPet(PetModel pet) async {
    final dto = PetMapper.toDto(pet);
    await _client.from('pets').insert(dto.toJson());
  }

  @override
  Future<void> updatePet(PetModel pet) async {
    final dto = PetMapper.toDto(pet);
    await _client.from('pets').update(dto.toJson()).eq('id', pet.id);
  }

  @override
  Future<void> deletePet(String id) async {
    await _client.from('pets').delete().eq('id', id);
  }
}
