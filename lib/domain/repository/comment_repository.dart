import 'package:catdog/domain/model/comment_model.dart';

abstract interface class CommentRepository {
  Future<void> addComment(CommentModel comment);
  Future<List<CommentModel>> getCommentsByFeedId(String feedId);
  Future<void> deleteComment(String id);
}
