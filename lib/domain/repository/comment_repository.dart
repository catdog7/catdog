import 'package:catdog/domain/model/comment_model.dart';

abstract interface class CommentRepository {
  Future<List<CommentModel>> getComments(String feedId);
  Future<void> addComment(CommentModel comment);
  Future<void> deleteComment(String commentId);
}
