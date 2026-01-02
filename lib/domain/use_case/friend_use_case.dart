import 'dart:async';

import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:catdog/domain/repository/user_repository.dart';

class FriendUseCase {
  final UserRepository _userRepo;
  final FriendRepository _friendRepo;
  final FollowRequestRepository _followRepo;
  FriendUseCase(this._userRepo, this._friendRepo, this._followRepo);

  Future<List<FriendInfoModel>> getMyFriends() async {
    //friendsA : userId == user_a_id 인 경우
    //friendsB : userId == user_b_id 인 경우
    final (friendsA, friendsB) = await _friendRepo.getAllFriends();
    List<FriendInfoModel> result = [];
    for (final friend in friendsA) {
      final userModel = await _userRepo.getUser(friend.userBId);
      if (userModel != null) {
        result.add(
          FriendInfoModel(
            userId: userModel.id,
            nickname: userModel.nickname,
            profileImageUrl: userModel.profileImageUrl,
            isFriend: true,
          ),
        );
      }
    }
    for (final friend in friendsB) {
      final userModel = await _userRepo.getUser(friend.userAId);
      if (userModel != null) {
        result.add(
          FriendInfoModel(
            userId: userModel.id,
            nickname: userModel.nickname,
            profileImageUrl: userModel.profileImageUrl,
            isFriend: true,
          ),
        );
      }
    }

    return result;
  }

  Future<bool> deleteFriend(String friendId) async {
    return await _friendRepo.deleteFriend(friendId);
  }

  Future<List<FriendInfoModel>> searchUsers(String nicknameOrCode) async {
    final users = await _friendRepo.findUsers(nicknameOrCode);
    List<FriendInfoModel> result = [];
    for (final user in users) {
      result.add(
        FriendInfoModel(
          userId: user.id,
          nickname: user.nickname,
          isFriend: false,
          profileImageUrl: user.profileImageUrl,
        ),
      );
    }
    return result;
  }

  Future<String> sendFollowRequest(String friendId) async {
    return await _followRepo.sendFollowRequest(friendId);
  }

  Future<List<FriendInfoModel>> getAllFollowRequest() async {
    final followRequests = await _followRepo.getAllFollowRequest();
    if (followRequests.isNotEmpty) {
      List<FriendInfoModel> result = [];
      for (final request in followRequests) {
        if (request.status == "PENDING") {
          final user = await _userRepo.getUser(request.fromUserId);
          if (user != null) {
            result.add(
              FriendInfoModel(
                userId: user.id,
                nickname: user.nickname,
                profileImageUrl: user.profileImageUrl,
                isFriend: false,
              ),
            );
          }
        }
      }
      return result;
    }
    return [];
  }

  Future<bool> acceptFollowRequest(String friendId) async {
    final result = await _followRepo.acceptFollowRequest(friendId);
    if (result) {
      await _friendRepo.addFriend(friendId);
      return true;
    }
    return false;
  }

  Future<bool> rejectFollowRequest(String friendId) async {
    return await _followRepo.rejectFollowRequest(friendId);
  }
}
