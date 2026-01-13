import 'package:catdog/domain/model/comment_model.dart';
import 'package:catdog/domain/model/user_model.dart';

abstract interface class CommentRepository {
  Future<List<CommentModel>> getComments(String feedId);
  Future<void> addComment(CommentModel comment);
  Future<bool> deleteComment(String commentId);
  Future<UserModel?> getMyInfo();
  Future<int> getCommentCount(String feedId);
}
