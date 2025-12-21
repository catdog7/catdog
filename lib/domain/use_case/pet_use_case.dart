import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/domain/repository/pet_repository.dart';

class PetUseCase {
  PetUseCase(this._repository);
  final PetRepository _repository;

  Future<void> addPet(PetModel pet) => _repository.addPet(pet);
  Future<List<PetModel>> getPets(String userId) => _repository.getPets(userId);
  Future<void> updatePet(PetModel pet) => _repository.updatePet(pet);
  Future<void> deletePet(String petId) => _repository.deletePet(petId);
}
