import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/ui/pages/friend/state/search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_search_view_model.g.dart';

@riverpod
class FriendSearchViewModel extends _$FriendSearchViewModel {
  @override
  Future<SearchState> build() async {
    final useCase = ref.watch(friendUseCaseProvider);
    //요청 중 PENDING인 것의 상대 아이디만 모으기
    final alarms = await useCase.getMyRequests();
    return SearchState(isLoading: false, users: []);
  }

  // 그때그때 최신으로 가져오게 바꾸기 -> SearchState에서 친구목록 알람목록 관리하지말기
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
    final users = await useCase.searchUsers(nicknameOrCode);
    state = AsyncData(state.value!.copyWith(isLoading: false, users: users));
  }

  Future<String> sendFollowRequest(String friendId) async {
    //
    final useCase = ref.read(friendUseCaseProvider);
    print("친구 요청 보냄");
    return await useCase.sendFollowRequest(friendId);
  }
}
