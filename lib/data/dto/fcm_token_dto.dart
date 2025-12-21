// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_dto.freezed.dart';
part 'fcm_token_dto.g.dart';

@freezed
class FcmTokenDto with _$FcmTokenDto {
  const factory FcmTokenDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String token,
    required String platform,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FcmTokenDto;

  factory FcmTokenDto.fromJson(Map<String, dynamic> json) => _$FcmTokenDtoFromJson(json);
}
