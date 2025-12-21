import 'package:catdog/domain/model/comment_model.dart';
import 'package:catdog/domain/repository/comment_repository.dart';

class CommentUseCase {
  CommentUseCase(this._repository);
  final CommentRepository _repository;

  Future<void> add(CommentModel comment) => _repository.addComment(comment);
  Future<List<CommentModel>> getByFeed(String feedId) => _repository.getCommentsByFeedId(feedId);
  Future<void> delete(String id) => _repository.deleteComment(id);
}
