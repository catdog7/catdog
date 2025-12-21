import 'package:amumal/core/config/profile_dependency.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/domain/use_case/profile_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_page_view_model.g.dart';

@riverpod
class LoginPageViewModel extends _$LoginPageViewModel {
  @override
  Future<UserModel?> build() async {
    return null;
  }

  Future<UserModel> getProfile() async {
    final profiles = await ref.read(profileUseCaseProvider).get();
    return profiles;
  }

  Future<void> addProfile({required UserModel user}) async {
    await ref.read(profileUseCaseProvider).add(user: user);
  }

  Future<bool> nicknameAvailable({required String nickname}) async {
    final result = await ref.read(profileUseCaseProvider).check(nickname);
    return result;
  }
}
