import 'package:catdog/domain/model/fcm_token_model.dart';

abstract interface class FcmTokenRepository {
  Future<void> saveToken(FcmTokenModel token);
  Future<void> deleteToken(String userId, String token);
  Future<List<FcmTokenModel>> getTokens(String userId);
}
