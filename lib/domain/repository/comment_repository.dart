import 'package:amumal/domain/model/comment_model.dart';

abstract class CommentRepository {
  /// 댓글 등록
  Future<CommentModel> createComment({required CommentModel comment});

  /// 특정 피드의 댓글 목록 조회
  Future<List<CommentModel>> getCommentsByFeedId({required String feedId});

  // 댓글 삭제
  Future<bool> deleteComment({required String commentId});

}
