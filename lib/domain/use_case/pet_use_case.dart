import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/domain/repository/pet_repository.dart';

class PetUseCase {
  final PetRepository _repository;

  PetUseCase(this._repository);

  Future<List<PetModel>> getMyPets(String userId) {
    return _repository.getPets(userId);
  }

  Future<void> addPet(PetModel pet) {
    return _repository.addPet(pet);
  }

  Future<void> updatePet(PetModel pet) {
    return _repository.updatePet(pet);
  }

  Future<void> removePet(String id) {
    return _repository.deletePet(id);
  }
}
