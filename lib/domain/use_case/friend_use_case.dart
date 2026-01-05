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
    // 내가 보낸 요청이 있으면 삭제, 상대가 보낸 것은 거절, 친구테이블에서 지우기
    final result = await Future.wait([
      _followRepo.rejectFollowRequest(friendId),
      _followRepo.deleteFollowRequest(friendId),
      _friendRepo.deleteFriend(friendId),
    ]);

    return result[2];
  }

  Future<List<FriendInfoModel>> searchUsers(String nicknameOrCode) async {
    //유저테이블에서 유저 가져오기
    final users = await _friendRepo.findUsers(nicknameOrCode);
    if (users.isNotEmpty) {
      List<FriendInfoModel> result = [];
      for (final user in users) {
        final results = await Future.wait([
          _friendRepo.isFriend(user.id),
          _followRepo.checkFollowPending(user.id),
        ]);

        result.add(
          FriendInfoModel(
            userId: user.id,
            nickname: user.nickname,
            isFriend: results[0],
            status: results[1] ? "PENDING" : null,
            profileImageUrl: user.profileImageUrl,
          ),
        );
      }
      return result;
    }
    return [];
  }

  Future<String> sendFollowRequest(String friendId) async {
    return await _followRepo.sendFollowRequest(friendId);
  }

  Future<List<FriendInfoModel>> getAllFollowRequest() async {
    final followRequests = await _followRepo.getAllFollowRequest();
    if (followRequests.isNotEmpty) {
      List<FriendInfoModel> result = [];
      for (final request in followRequests) {
        final user = await _userRepo.getUser(request.fromUserId);
        if (user != null) {
          final isFriend = await _friendRepo.isFriend(user.id);
          result.add(
            FriendInfoModel(
              userId: user.id,
              nickname: user.nickname,
              profileImageUrl: user.profileImageUrl,
              isFriend: isFriend,
              status: request.status,
            ),
          );
        }
      }
      return result;
    }
    return [];
  }

  Future<List<String>> getMyRequests() async {
    final myRequests = await _followRepo.getMyRequests();
    if (myRequests.isNotEmpty) {
      return myRequests
          //.where((e) => e.status == "PENDING")
          .map((e) => e.toUserId)
          .toList();
    }
    print("내가 보낸 요청 없음");
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
