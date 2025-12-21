import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/user_repository.dart';

class UserUseCase {
  final UserRepository _repository;

  UserUseCase(this._repository);

  Future<UserModel?> getUserProfile(String id) {
    return _repository.getUser(id);
  }

  Future<void> registerUser(UserModel user) {
    return _repository.addUser(user);
  }

  Future<void> updateProfile(UserModel user) {
    return _repository.updateUser(user);
  }
}
