import 'package:catdog/domain/model/user_model.dart';

abstract interface class UserRepository {
  Future<void> addUser({required UserModel user});
  Future<UserModel> getUser(String userId);
  Future<bool> hasProfile(String userId);
  Future<bool> nicknameAvailable({required String nickname});
}