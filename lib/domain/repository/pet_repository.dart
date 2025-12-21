import 'package:catdog/domain/model/pet_model.dart';

abstract interface class PetRepository {
  Future<void> addPet(PetModel pet);
  Future<List<PetModel>> getPets(String userId);
  Future<void> updatePet(PetModel pet);
  Future<void> deletePet(String petId);
}
