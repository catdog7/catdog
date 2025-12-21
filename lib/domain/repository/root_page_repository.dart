import 'package:amumal/domain/model/user_model.dart';

abstract class RootPageRepository {
  Future<bool> hasProfile(String deviceId);
   Future<UserModel?> getProfile(String deviceId);
}