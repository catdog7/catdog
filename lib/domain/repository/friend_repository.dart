import 'package:catdog/domain/model/friend_model.dart';

abstract interface class FriendRepository {
  Future<List<FriendModel>> getAllFriends(String userId);
  Future<bool> addFriend(FriendModel friend);
  Future<bool> deleteFriend(String userAID, String userBID);
}
