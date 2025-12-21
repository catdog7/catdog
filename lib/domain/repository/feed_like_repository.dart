import 'package:catdog/domain/model/feed_like_model.dart';

abstract interface class FeedLikeRepository {
  Future<void> likeFeed(FeedLikeModel like);
  Future<void> unlikeFeed(String feedId, String userId);
  Future<bool> isLiked(String feedId, String userId);
  Future<int> getLikeCount(String feedId);
}
