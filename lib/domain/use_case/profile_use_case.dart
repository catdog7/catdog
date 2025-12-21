import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/domain/repository/profile_repository.dart';

class ProfileUseCase {
      ProfileUseCase(this.profilerepo);
  final ProfileRepository profilerepo;


  Future<void> add({required UserModel user}) => profilerepo.addProfile(user: user);

   Future<UserModel> get() => profilerepo.getProfile();


  Future<bool> check(String nickname) => profilerepo.nicknameAvailable(nickname:nickname);
}