import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/domain/repository/profile_repository.dart';
import 'package:amumal/domain/repository/root_page_repository.dart';

class RootUseCase {
  RootUseCase(this.repository);
  final RootPageRepository repository;

  

  Future<(bool hasProfile, UserModel? profile)> execute(String deviceId) async {
    final hasProfile = await repository.hasProfile(deviceId);
    final profile = await repository.getProfile(deviceId);

    return (hasProfile, profile);
  }
}