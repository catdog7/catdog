import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/ui/pages/home/state/friend_home_request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_home_request_view_model.g.dart';

@riverpod
class FriendHomeRequestViewModel extends _$FriendHomeRequestViewModel {
  @override
  Future<FriendHomeRequestState> build(String friendId) async {
    final useCase = ref.watch(friendUseCaseProvider);
    final (isFriend, isSendPending, isReceivePending) = await useCase
        .checkFriendStatus(friendId);
    // print(
    //   "!!!!!!!! isFriend : $isFriend, isSendPending: $isSendPending, isReceivePending : $isReceivePending!!!!!!!",
    // );
    return FriendHomeRequestState(
      isLoading: false,
      isFriend: isFriend,
      isSendPending: isSendPending,
      isReceivePending: isReceivePending,
    );
  }

  Future<void> sendFollowRequest(String friendId) async {
    if (state.value == null || state.value!.isLoading) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    final useCase = ref.read(friendUseCaseProvider);
    print("친구 요청 보냄");
    state = AsyncData(state.value!.copyWith(isSendPending: true));
    final result = await useCase.sendFollowRequest(friendId);
    if (result == "SUCCESS") {
      state = AsyncData(state.value!.copyWith(isLoading: false));
    } else {
      state = AsyncData(
        state.value!.copyWith(isLoading: false, isSendPending: false),
      );
    }
  }

  Future<void> deleteFriend(String friendId) async {
    if (state.value == null || state.value!.isLoading) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));

    final useCase = ref.read(friendUseCaseProvider);
    final result = await useCase.deleteFriend(friendId);
    if (!result) {
      // db에서 삭제 실패하면 로컬에서 다시 되돌리기
      state = AsyncData(
        state.value!.copyWith(
          isLoading: false,
          isFriend: true,
          isSendPending: false,
          isReceivePending: false,
        ),
      );
    } else {
      state = AsyncData(
        state.value!.copyWith(
          isLoading: false,
          isFriend: false,
          isSendPending: false,
          isReceivePending: false,
        ),
      );
      print("친구 삭제 완료!!!!!!");
    }
  }
}
