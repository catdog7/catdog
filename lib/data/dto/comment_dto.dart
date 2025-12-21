// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_dto.freezed.dart';
part 'comment_dto.g.dart';

@freezed
class CommentDto with _$CommentDto {
  const factory CommentDto({
    required String id,
    @JsonKey(name: 'feed_id') required String feedId,
    @JsonKey(name: 'user_id') required String userId,
    required String content,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CommentDto;

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);
}
