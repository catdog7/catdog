// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_dto.freezed.dart';
part 'friend_dto.g.dart';

@freezed
class FriendDto with _$FriendDto {
  const factory FriendDto({
    required String id,
    @JsonKey(name: 'user_a_id') required String userAId,
    @JsonKey(name: 'user_b_id') required String userBId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FriendDto;

  factory FriendDto.fromJson(Map<String, dynamic> json) => _$FriendDtoFromJson(json);
}
