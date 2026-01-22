import 'package:catdog/domain/repository/block_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'block_repository_impl.g.dart';

class BlockRepositoryImpl implements BlockRepository {
  final SupabaseClient _supabase;

  BlockRepositoryImpl(this._supabase);

  @override
  Future<void> blockUser(String blockedUserId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("로그인이 필요합니다.");

    await _supabase.from('blocks').insert({
      'blocker_id': user.id,
      'blocked_id': blockedUserId,
    });
  }

  @override
  Future<void> unblockUser(String blockedUserId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("로그인이 필요합니다.");

    await _supabase
        .from('blocks')
        .delete()
        .eq('blocker_id', user.id)
        .eq('blocked_id', blockedUserId);
  }

  @override
  Future<List<String>> getBlockedUserIds(String userId) async {
    print("getBlockedUserIds 호출됨. userId: $userId"); // 디버깅
    final response = await _supabase
        .from('blocks')
        .select('blocked_id')
        .eq('blocker_id', userId);

    print("DB Response Data: $response"); // 디버깅

    final List<dynamic> data = response;
    return data
        .map((e) => e['blocked_id'])
        .where((e) => e != null)
        .map((e) => e.toString())
        .toList();
  }

  @override
  Future<List<String>> getBlockedByAndBlockingUserIds(String userId) async {
    // 1. 내가 차단한 유저
    final blockingResponse = await _supabase
        .from('blocks')
        .select('blocked_id')
        .eq('blocker_id', userId);
    
    // 2. 나를 차단한 유저
    final blockedByResponse = await _supabase
        .from('blocks')
        .select('blocker_id')
        .eq('blocked_id', userId);

    final Set<String> ids = {};
    for (var item in blockingResponse) {
      ids.add(item['blocked_id'] as String);
    }
    for (var item in blockedByResponse) {
      ids.add(item['blocker_id'] as String);
    }

    return ids.toList();
  }
}

@riverpod
BlockRepository blockRepository(Ref ref) {
  return BlockRepositoryImpl(Supabase.instance.client);
}
