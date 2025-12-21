import 'package:catdog/domain/model/user_model.dart';

abstract interface class UserRepository {
  Future<UserModel?> getUser(String id);
  Future<void> addUser(UserModel user);
  Future<void> updateUser(UserModel user);
}
