import 'package:catdog/domain/model/user_model.dart';

abstract interface class UserRepository {
  Future<UserModel?> getUser(String id);
  Future<bool> hasNickname(String id);
  Future<bool> nicknameExists(String nickname);
  Future<bool> inviteCodeExists(String inviteCode);
  Future<void> addUser(UserModel user);
  Future<void> createUserIfNotExists(String id, String inviteCode, {String? email, String? provider});
  Future<void> updateUser(UserModel user);
  Future<void> updateNickname(String id, String nickname);
}
