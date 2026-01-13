import 'package:catdog/domain/repository/comment_repository.dart';
import 'package:catdog/domain/repository/feed_like_repository.dart';

class FeedLikeUseCase {
  FeedLikeUseCase(this._commentRepo, this._feedLikeRepo);
  final CommentRepository _commentRepo;
  final FeedLikeRepository _feedLikeRepo;

  Future<({int commentCount, int likeCount, bool isLiked})> getFeedStats(
    String feedId,
  ) async {
    final results = await Future.wait([
      _commentRepo.getCommentCount(feedId),
      _feedLikeRepo.getFeedLikeCount(feedId),
      _feedLikeRepo.checkLiked(feedId),
    ]);
    return (
      commentCount: results[0] as int,
      likeCount: results[1] as int,
      isLiked: results[2] as bool,
    );
  }

  Future<void> toggleLike(String feedId, bool updatedLike) async {
    if (updatedLike) {
      await _feedLikeRepo.addLiked(feedId);
    } else {
      await _feedLikeRepo.deleteLiked(feedId);
    }
  }

  Future<({int commentCount, int likeCount})> getCounts(String feedId) async {
    final results = await Future.wait([
      _commentRepo.getCommentCount(feedId),
      _feedLikeRepo.getFeedLikeCount(feedId),
    ]);
    return (commentCount: results[0], likeCount: results[1]);
  }
}
