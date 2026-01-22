import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_like_model.freezed.dart';

@freezed
class CommentLikeModel with _$CommentLikeModel {
  const factory CommentLikeModel({
    required String id,
    required String commentId,
    required String userId,
    required DateTime createdAt,
  }) = _CommentLikeModel;
}
