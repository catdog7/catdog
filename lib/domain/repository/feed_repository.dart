import 'package:catdog/domain/model/feed_model.dart';

abstract interface class FeedRepository {
  Future<void> addFeed(FeedModel feed);
  Future<FeedModel> getFeed(String id);
  Future<List<FeedModel>> getFeedsByUserId(String userId);
  Future<List<FeedModel>> getFriendFeeds(String userId, {int limit = 20, DateTime? before});
  Future<void> updateFeed(FeedModel feed);
  Future<void> deleteFeed(String id);
}
