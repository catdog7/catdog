import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_model.freezed.dart';

@freezed
class FcmTokenModel with _$FcmTokenModel {
  const factory FcmTokenModel({
    required String id,
    required String userId,
    required String token,
    required String platform,
    DateTime? createdAt,
  }) = _FcmTokenModel;
}
