import 'package:catdog/domain/model/fcm_token_model.dart';

abstract interface class TokenRepository {
  Future<void> addToken(FcmTokenModel token);
  Future<void> updateToken(FcmTokenModel token);
  Future<void> deleteToken(String userId);
}
