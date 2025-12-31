import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/state/friend_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_alarm_view_model.g.dart';

@riverpod
class FriendAlarmViewModel extends _$FriendAlarmViewModel {
  @override
  Future<FriendState> build() async {
    final useCase = ref.watch(friendUseCaseProvider);
    final requests = await useCase.getAllFollowRequest();
    return FriendState(isLoading: false, friends: requests);
  }

  Future<void> refresh() async {
    if (state.value == null || state.value!.isLoading) {
      return;
    }

    final useCase = ref.watch(friendUseCaseProvider);
    final requests = await useCase.getAllFollowRequest();

    state = AsyncData(FriendState(isLoading: false, friends: requests));
  }

  Future<void> rejectRequest(String friendId) async {
    if (state.value == null ||
        state.value!.isLoading ||
        state.value!.friends.isEmpty) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));

    //롤백용
    final oldList = state.value!.friends.toList();

    //로컬에서 지우기
    List<FriendInfoModel> newList = state.value!.friends.toList();
    newList.removeWhere((e) => e.userId == friendId);
    state = AsyncData(state.value!.copyWith(friends: newList));

    final useCase = ref.read(friendUseCaseProvider);
    final result = await useCase.rejectFollowRequest(friendId);
    if (result) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
    } else {
      //서버에서 거절안되면 다시 롤백
      state = AsyncData(FriendState(isLoading: false, friends: oldList));
    }
  }

  Future<bool> acceptFollowRequest(String friendId) async {
    if (state.value == null ||
        state.value!.isLoading ||
        state.value!.friends.isEmpty) {
      return false;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));

    //롤백용
    final oldList = state.value!.friends.toList();

    //로컬에서 지우기
    List<FriendInfoModel> newList = state.value!.friends.toList();
    newList.removeWhere((e) => e.userId == friendId);
    state = AsyncData(state.value!.copyWith(friends: newList));

    final useCase = ref.read(friendUseCaseProvider);
    final result = await useCase.acceptFollowRequest(friendId);
    if (result) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      return true;
    } else {
      //서버에서 거절안되면 다시 롤백
      state = AsyncData(FriendState(isLoading: false, friends: oldList));
      return false;
    }
  }
}
