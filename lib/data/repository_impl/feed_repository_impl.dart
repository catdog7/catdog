import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/domain/repository/feed_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // ✅ Ref를 사용하기 위해 추가
part 'feed_repository_impl.g.dart';

class FeedRepositoryImpl implements FeedRepository {
  final SupabaseClient _supabase;
  FeedRepositoryImpl(this._supabase);

  @override
  Future<List<FeedDto>> getFeeds() async {
    final response = await _supabase
        .from('feeds')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => FeedDto.fromJson(json)).toList();
  }
}

// ✅ Provider 생성 (ViewModel에서 쓸 수 있도록)
@riverpod
FeedRepository feedRepository(Ref ref) {
  return FeedRepositoryImpl(Supabase.instance.client);
}