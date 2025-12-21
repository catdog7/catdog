import 'package:catdog/domain/model/friend_model.dart';
import 'package:catdog/domain/repository/friend_repository.dart';

class FriendUseCase {
  FriendUseCase(this._repository);
  final FriendRepository _repository;

  Future<void> add(FriendModel friend) => _repository.addFriend(friend);
  Future<void> remove(String userAId, String userBId) => _repository.removeFriend(userAId, userBId);
  Future<List<FriendModel>> getFriends(String userId) => _repository.getFriends(userId);
  Future<bool> isFriend(String userId, String otherId) => _repository.isFriend(userId, otherId);
}
