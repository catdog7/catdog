import 'package:catdog/domain/model/feed_model.dart';
import 'package:catdog/domain/repository/feed_repository.dart';

class FeedUseCase {
  FeedUseCase(this._repository);
  final FeedRepository _repository;

  Future<void> add(FeedModel feed) => _repository.addFeed(feed);
  Future<FeedModel> get(String id) => _repository.getFeed(id);
  Future<List<FeedModel>> getByUser(String userId) => _repository.getFeedsByUserId(userId);
  Future<List<FeedModel>> getFeeds(String userId, {int limit = 20, DateTime? before}) => 
      _repository.getFriendFeeds(userId, limit: limit, before: before);
  Future<void> update(FeedModel feed) => _repository.updateFeed(feed);
  Future<void> delete(String id) => _repository.deleteFeed(id);
}
