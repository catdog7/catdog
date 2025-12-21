import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String feedId,
    required String userId,
    required String content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CommentModel;
}
