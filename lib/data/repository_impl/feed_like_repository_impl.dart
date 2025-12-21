import 'package:catdog/data/mapper/feed_like_mapper.dart';
import 'package:catdog/domain/model/feed_like_model.dart';
import 'package:catdog/domain/repository/feed_like_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedLikeRepositoryImpl implements FeedLikeRepository {
  FeedLikeRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> likeFeed(FeedLikeModel like) async {
    final dto = FeedLikeMapper.toDto(like);
    await client.from('feed_likes').insert(dto.toJson());
  }

  @override
  Future<void> unlikeFeed(String feedId, String userId) async {
    await client.from('feed_likes').delete().eq('feed_id', feedId).eq('user_id', userId);
  }

  @override
  Future<bool> isLiked(String feedId, String userId) async {
    final data = await client.from('feed_likes').select('id').eq('feed_id', feedId).eq('user_id', userId).maybeSingle();
    return data != null;
  }

  @override
  Future<int> getLikeCount(String feedId) async {
    final res = await client.from('feed_likes').select('id').eq('feed_id', feedId);
    return (res as List).length;
  }
}
