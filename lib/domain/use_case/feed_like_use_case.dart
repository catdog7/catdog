import 'package:catdog/domain/model/feed_like_model.dart';
import 'package:catdog/domain/repository/feed_like_repository.dart';

class FeedLikeUseCase {
  FeedLikeUseCase(this._repository);
  final FeedLikeRepository _repository;

  Future<void> like(FeedLikeModel like) => _repository.likeFeed(like);
  Future<void> unlike(String feedId, String userId) => _repository.unlikeFeed(feedId, userId);
  Future<bool> isLiked(String feedId, String userId) => _repository.isLiked(feedId, userId);
  Future<int> getCount(String feedId) => _repository.getLikeCount(feedId);
}
