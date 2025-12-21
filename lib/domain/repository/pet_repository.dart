import 'package:catdog/domain/model/pet_model.dart';

abstract interface class PetRepository {
  Future<List<PetModel>> getPets(String userId);
  Future<void> addPet(PetModel pet);
  Future<void> updatePet(PetModel pet);
  Future<void> deletePet(String id);
}
