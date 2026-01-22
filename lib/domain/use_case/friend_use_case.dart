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
    // List<FriendInfoModel> result = [];
    // for (final friend in friendsA) {
    //   final userModel = await _userRepo.getUser(friend.userBId);
    //   if (userModel != null) {
    //     result.add(
    //       FriendInfoModel(
    //         userId: userModel.id,
    //         nickname: userModel.nickname,
    //         profileImageUrl: userModel.profileImageUrl,
    //         isFriend: true,
    //       ),
    //     );
    //   }
    // }
    // for (final friend in friendsB) {
    //   final userModel = await _userRepo.getUser(friend.userAId);
    //   if (userModel != null) {
    //     result.add(
    //       FriendInfoModel(
    //         userId: userModel.id,
    //         nickname: userModel.nickname,
    //         profileImageUrl: userModel.profileImageUrl,
    //         isFriend: true,
    //       ),
    //     );
    //   }
    // }

    // 비동기 작업 동시에
    final futuresA = friendsA.map((friend) async {
      final userModel = await _userRepo.getUser(friend.userBId);
      if (userModel == null) return null;
      return FriendInfoModel(
        userId: userModel.id,
        nickname: userModel.nickname,
        profileImageUrl: userModel.profileImageUrl,
        isFriend: true,
      );
    });

    final futuresB = friendsB.map((friend) async {
      final userModel = await _userRepo.getUser(friend.userAId);
      if (userModel == null) return null;
      return FriendInfoModel(
        userId: userModel.id,
        nickname: userModel.nickname,
        profileImageUrl: userModel.profileImageUrl,
        isFriend: true,
      );
    });

    final results = await Future.wait([...futuresA, ...futuresB]);

    List<FriendInfoModel> result = results
        .whereType<FriendInfoModel>()
        .toList();

    result.sort((a, b) => (a.nickname ?? '').compareTo(b.nickname ?? ''));
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
    // if (users.isNotEmpty) {
    //   List<FriendInfoModel> result = [];
    //   for (final user in users) {
    //     final results = await Future.wait([
    //       _friendRepo.isFriend(user.id),
    //       _followRepo.checkFollowPending(user.id),
    //     ]);

    //     result.add(
    //       FriendInfoModel(
    //         userId: user.id,
    //         nickname: user.nickname,
    //         isFriend: results[0],
    //         status: results[1] ? "PENDING" : null,
    //         profileImageUrl: user.profileImageUrl,
    //       ),
    //     );
    //   }
    //   return result;
    // }

    // 비동기 작업 동시에
    if (users.isNotEmpty) {
      final futures = users.map((user) async {
        final statusResults = await Future.wait([
          _friendRepo.isFriend(user.id),
          _followRepo.checkFollowPending(user.id),
        ]);

        return FriendInfoModel(
          userId: user.id,
          nickname: user.nickname,
          isFriend: statusResults[0],
          status: (statusResults[1]) ? "PENDING" : null,
          profileImageUrl: user.profileImageUrl,
        );
      }).toList();

      return await Future.wait(futures);
    }
    return [];
  }

  Future<String> sendFollowRequest(String friendId) async {
    return await _followRepo.sendFollowRequest(friendId);
  }

  Future<List<FriendInfoModel>> getAllFollowRequest() async {
    final followRequests = await _followRepo.getAllFollowRequest();
    // if (followRequests.isNotEmpty) {
    //   List<FriendInfoModel> result = [];
    //   for (final request in followRequests) {
    //     final user = await _userRepo.getUser(request.fromUserId);
    //     if (user != null) {
    //       final isFriend = await _friendRepo.isFriend(user.id);
    //       result.add(
    //         FriendInfoModel(
    //           userId: user.id,
    //           nickname: user.nickname,
    //           profileImageUrl: user.profileImageUrl,
    //           isFriend: isFriend,
    //           status: request.status,
    //         ),
    //       );
    //     }
    //   }
    //   return result;
    // }
    // return [];

    // 비동기 동시에 진행
    if (followRequests.isEmpty) return [];

    final futures = followRequests.map((request) async {
      final user = await _userRepo.getUser(request.fromUserId);
      if (user == null) return null;

      final isFriend = await _friendRepo.isFriend(user.id);

      return FriendInfoModel(
        userId: user.id,
        nickname: user.nickname,
        profileImageUrl: user.profileImageUrl,
        isFriend: isFriend,
        status: request.status,
      );
    }).toList();

    final results = await Future.wait(futures);

    return results.whereType<FriendInfoModel>().toList();
  }

  Future<List<String>> getMyRequests() async {
    final myRequests = await _followRepo.getMyRequests();
    if (myRequests.isNotEmpty) {
      return myRequests.map((e) => e.toUserId).toList();
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

  Future<(bool isFriend, bool isSendPending, bool isReceivePending)>
  checkFriendStatus(String friendId) async {
    final result = await Future.wait([
      _friendRepo.isFriend(friendId),
      _followRepo.checkFollowPending(friendId),
      _followRepo.checkRequestPending(friendId),
    ]);

    return (result[0], result[1], result[2]);
  }
}
