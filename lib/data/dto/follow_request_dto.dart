// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_request_dto.freezed.dart';
part 'follow_request_dto.g.dart';

@freezed
class FollowRequestDto with _$FollowRequestDto {
  const factory FollowRequestDto({
    required String id,
    @JsonKey(name: 'from_user_id') required String fromUserId,
    @JsonKey(name: 'to_user_id') required String toUserId,
    @Default('PENDING') String status,
    @Default('FRIEND') String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FollowRequestDto;

  factory FollowRequestDto.fromJson(Map<String, dynamic> json) => _$FollowRequestDtoFromJson(json);
}
