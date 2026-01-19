// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    String? nickname,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    String? email,
    String? provider,
    @Default('ACTIVE') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}
