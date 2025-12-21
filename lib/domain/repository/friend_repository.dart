import 'package:catdog/domain/model/friend_model.dart';

abstract interface class FriendRepository {
  Future<void> addFriend(FriendModel friend);
  Future<void> removeFriend(String userAId, String userBId);
  Future<List<FriendModel>> getFriends(String userId);
  Future<bool> isFriend(String userId, String otherId);
}
