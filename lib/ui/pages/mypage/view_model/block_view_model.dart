import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/data/dto/user_dto.dart';
import 'package:catdog/data/repository_impl/block_repository_impl.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_view_model.g.dart';

@riverpod
class BlockViewModel extends _$BlockViewModel {
  @override
  FutureOr<List<UserModel>> build() async {
    return _fetchBlockedUsers();
  }

  Future<List<UserModel>> _fetchBlockedUsers() async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final blockRepo = ref.read(blockRepositoryProvider);
      final blockedIds = await blockRepo.getBlockedUserIds(userId);

      if (blockedIds.isEmpty) return [];

      // 차단된 유저들의 상세 정보 조회
      final response = await client
          .from('users')
          .select()
          .filter('id', 'in', blockedIds);

      final List<dynamic> data = response;
      return data.map((json) => UserModel.fromJson(UserDto.fromJson(json).toJson())).toList();
    } catch (e) {
      print("차단 목록 조회 실패: $e");
      return [];
    }
  }

  Future<void> unblockUser(String blockedUserId) async {
    try {
      final blockRepo = ref.read(blockRepositoryProvider);
      await blockRepo.unblockUser(blockedUserId);

      // 리스트 갱신 (로컬에서 제거)
      final currentList = state.value ?? [];
      state = AsyncData(currentList.where((user) => user.id != blockedUserId).toList());
    } catch (e) {
      print("차단 해제 실패: $e");
    }
  }
}
