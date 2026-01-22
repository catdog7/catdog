import 'package:catdog/domain/model/comment_info_model.dart';
import 'package:catdog/domain/model/comment_model.dart';
import 'package:catdog/domain/repository/comment_like_repository.dart';
import 'package:catdog/domain/repository/comment_repository.dart';
import 'package:catdog/domain/repository/user_repository.dart';
import 'package:catdog/domain/model/user_model.dart';

class CommentUseCase {
  final CommentRepository _commentRepo;
  final CommentLikeRepository _commentLikeRepo;
  final UserRepository _userRepo;
  CommentUseCase(this._commentRepo, this._commentLikeRepo, this._userRepo);

  Future<List<CommentInfoModel>> getAllComments(String feedId) async {
    final comments = await _commentRepo.getComments(feedId);

    final List<Future<CommentInfoModel?>> futures = comments.map((e) async {
      final [
        dynamic userResult,
        dynamic isLikeResult,
        dynamic likeCountResult,
      ] = await Future.wait<dynamic>([
        _userRepo.getUser(e.userId),
        _commentLikeRepo.checkLiked(e.id),
        _commentLikeRepo.getCommentLikeCount(e.id),
      ]);

      final user = userResult as UserModel?;
      final isLike = isLikeResult as bool;
      final likeCount = likeCountResult as int;

      if (user != null) {
        return CommentInfoModel(
          id: e.id,
          userId: e.userId,
          nickname: user.nickname,
          content: e.content,
          createdAt: e.createdAt,
          isLike: isLike,
          likeCount: likeCount,
          profileImageUrl: user.profileImageUrl,
        );
      }
      return null;
    }).toList();

    final List<CommentInfoModel?> results = await Future.wait(futures);

    return results.whereType<CommentInfoModel>().toList();
  }

  Future<void> addcomment(CommentModel comment) async {
    await _commentRepo.addComment(comment);
  }

  Future<bool> deleteComment(String commentId) async {
    return await _commentRepo.deleteComment(commentId);
  }

  Future<void> toggleLike(String commentId, bool updatedLike) async {
    if (updatedLike) {
      await _commentLikeRepo.addLiked(commentId);
    } else {
      await _commentLikeRepo.deleteLiked(commentId);
    }
  }

  Future<UserModel?> getMyInfo() async {
    return await _commentRepo.getMyInfo();
  }
}
