import 'dart:async';
import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/state/friend_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_view_model.g.dart';

@riverpod
class FriendViewModel extends _$FriendViewModel {
  @override
  Future<FriendState> build() async {
    final useCase = ref.watch(friendUseCaseProvider);
    final friends = await useCase.getMyFriends();
    return FriendState(isLoading: false, friends: friends);
  }

  Future<void> refresh() async {
    if (state.value == null || state.value!.isLoading) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(friendUseCaseProvider);
      final newList = await useCase.getMyFriends();
      print("친구 목록 리프레시!!!");
      return FriendState(isLoading: false, friends: newList);
    });
  }

  Future<void> deleteFriend(String friendId) async {
    if (state.value == null ||
        state.value!.isLoading ||
        state.value!.friends.isEmpty) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));

    final oldList = state.value!.friends.toList();
    final indexTodelete = state.value!.friends.indexWhere(
      (friend) => friend.userId == friendId,
    );

    // 없으면 조기 종료
    if (indexTodelete == -1) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      return;
    }

    //로컬에서 삭제
    final newList = List<FriendInfoModel>.from(state.value!.friends);
    newList.removeAt(indexTodelete);
    state = AsyncData(state.value!.copyWith(friends: newList));

    final useCase = ref.read(friendUseCaseProvider);
    final result = await useCase.deleteFriend(friendId);
    if (!result) {
      // db에서 삭제 실패하면 로컬에서 다시 되돌리기
      state = AsyncData(
        state.value!.copyWith(isLoading: false, friends: oldList),
      );
    } else {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      print("친구 삭제 완료!!!!!!");
    }
  }

  Future<bool> initFcmToken() async {
    final messaging = FirebaseMessaging.instance;

    // APNS 토큰 준비 확인
    // final apnsToken = await messaging.getAPNSToken();
    // if (apnsToken == null) {
    //   print('APNS token not ready yet');
    //   return false;
    // }

    final fcmToken = await messaging.getToken();
    if (fcmToken == null) return false;

    return true;
  }
}
