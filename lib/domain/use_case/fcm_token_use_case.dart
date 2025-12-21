import 'package:catdog/domain/model/fcm_token_model.dart';
import 'package:catdog/domain/repository/fcm_token_repository.dart';

class FcmTokenUseCase {
  FcmTokenUseCase(this._repository);
  final FcmTokenRepository _repository;

  Future<void> save(FcmTokenModel token) => _repository.saveToken(token);
  Future<void> delete(String userId, String token) => _repository.deleteToken(userId, token);
  Future<List<FcmTokenModel>> getTokens(String userId) => _repository.getTokens(userId);
}
