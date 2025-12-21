import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

@freezed
class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    String? id,
    required String writerId,
    required String feedId,
    required String nickname,
    required String content,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) = _CommentModel;

  /// 생성자에서 content가 100자 이하인지 검증
  factory CommentModel.create({
    String? id,
    required String writerId,
    required String feedId,
    required String nickname,
    required String content,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) {
    if (content.length > 100) {
      throw ArgumentError(
        '댓글은 100자 이하여야 합니다. (현재: ${content.length}자)',
        'content',
      );
    }
    return CommentModel(
      id: id,
      writerId: writerId,
      feedId: feedId,
      nickname: nickname,
      content: content,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
    );
  }
}