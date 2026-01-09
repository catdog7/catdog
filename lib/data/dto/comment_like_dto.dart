// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_like_dto.freezed.dart';
part 'comment_like_dto.g.dart';

@freezed
class CommentLikeDto with _$CommentLikeDto {
  const factory CommentLikeDto({
    required String id,
    @JsonKey(name: 'comment_id') required String commentId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommentLikeDto;

  factory CommentLikeDto.fromJson(Map<String, dynamic> json) =>
      _$CommentLikeDtoFromJson(json);
}
