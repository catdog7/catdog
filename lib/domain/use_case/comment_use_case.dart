import 'package:amumal/domain/model/comment_model.dart';
import 'package:amumal/domain/repository/comment_repository.dart';

class CommentUseCase {
  const CommentUseCase({required this.commentRepo});
  final CommentRepository commentRepo;

  /// 댓글 등록
  /// UseCase에서 앱의 정책을 처리: 등록 시 createdAt, modifiedAt을 자동으로 설정
  Future<CommentModel> createComment({
    required String writerId,
    required String feedId,
    required String nickname,
    required String content,
  }) async {
    
    final now = DateTime.now();
    final comment = CommentModel(
      writerId: writerId,
      feedId: feedId,
      nickname: nickname,
      content: content,
      createdAt: now,
      modifiedAt: now,
    );
    return commentRepo.createComment(comment: comment);
  }

  /// 특정 피드의 댓글 목록 조회
  Future<List<CommentModel>> getCommentsByFeedId({
    required String feedId,
  }) => commentRepo.getCommentsByFeedId(feedId: feedId);

  // 댓글 삭제
  Future<bool> deleteComment({required String commentId}) =>
      commentRepo.deleteComment(commentId: commentId);
}
