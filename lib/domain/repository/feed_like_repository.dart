abstract interface class FeedLikeRepository {
  Future<int> getFeedLikeCount(String feedId);
  Future<bool> checkLiked(String feedId);
  Future<void> deleteLiked(String feedId);
  Future<void> addLiked(String feedId);
}
