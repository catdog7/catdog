import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/state/search_state.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_search_view_model.g.dart';

@riverpod
class FriendSearchViewModel extends _$FriendSearchViewModel {
  @override
  Future<SearchState> build() async {
    final useCase = ref.watch(friendUseCaseProvider);
    final friendvm = ref.watch(friendViewModelProvider);
    final friendList = friendvm.value?.friends;
    List<String> friendIds = [];
    if (friendList != null) {
      for (final friend in friendList) {
        friendIds.add(friend.userId);
      }
    }
    return SearchState(isLoading: false, friendIds: friendIds, users: []);
  }

  Future<void> searchUsers(String nicknameOrCode) async {
    if (state.value == null || state.value!.isLoading) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    if (nicknameOrCode.isEmpty) {
      state = AsyncData(state.value!.copyWith(isLoading: false, users: []));
      return;
    }

    final useCase = ref.read(friendUseCaseProvider);
    List<FriendInfoModel> users = await useCase.searchUsers(nicknameOrCode);

    if (users.isEmpty) {
      state = AsyncData(state.value!.copyWith(isLoading: false, users: []));
      return;
    }

    final friendIds = state.value!.friendIds;
    if (friendIds.isNotEmpty) {
      for (var user in users) {
        if (friendIds.contains(user.userId)) {
          user = user.copyWith(isFriend: true);
        }
      }
    }
    state = AsyncData(state.value!.copyWith(isLoading: false, users: users));
  }

  Future<void> sendFollowRequest(String friendId) async {
    //
    final useCase = ref.read(friendUseCaseProvider);
    print("친구 요청 보냄");
  }
}
