import 'package:catdog/domain/model/friend_model.dart';
import 'package:catdog/domain/model/user_model.dart';

abstract interface class FriendRepository {
  Future<(List<FriendModel>, List<FriendModel>)> getAllFriends();
  Future<bool> addFriend(FriendModel friend);
  Future<bool> deleteFriend(String friendId);
  Future<List<UserModel>> findUsers(String nicknameOrCode);
}
