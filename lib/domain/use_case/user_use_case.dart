import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/user_repository.dart';

class UserUseCase {
  UserUseCase(this._repository);
  final UserRepository _repository;

  Future<void> add({required UserModel user}) => _repository.addUser(user: user);
  Future<UserModel> get(String userId) => _repository.getUser(userId);
  Future<bool> hasProfile(String userId) => _repository.hasProfile(userId);
  Future<bool> checkNickname(String nickname) => _repository.nicknameAvailable(nickname: nickname);
}