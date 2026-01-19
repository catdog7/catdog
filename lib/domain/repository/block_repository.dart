abstract class BlockRepository {
  Future<void> blockUser(String blockedUserId);
  Future<void> unblockUser(String blockedUserId);
  Future<List<String>> getBlockedUserIds(String userId); // 내가 차단한 유저들
  Future<List<String>> getBlockedByAndBlockingUserIds(String userId); // 차단 양방향 (검색 필터링용)
}
