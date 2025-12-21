import 'package:amumal/domain/model/user_model.dart';

abstract interface class ProfileRepository {
  Future<void> addProfile({required UserModel user});
  Future<UserModel> getProfile();
  Future<bool> nicknameAvailable({required String nickname});
}