import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/data/mapper/feed_mapper.dart';
import 'package:catdog/domain/model/feed_model.dart';
import 'package:catdog/domain/repository/feed_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> addFeed(FeedModel feed) async {
    final dto = FeedMapper.toDto(feed);
    await client.from('feeds').insert(dto.toJson());
  }

  @override
  Future<FeedModel> getFeed(String id) async {
    final data = await client.from('feeds').select().eq('id', id).single();
    return FeedMapper.toDomain(FeedDto.fromJson(data));
  }

  @override
  Future<List<FeedModel>> getFeedsByUserId(String userId) async {
    final data = await client.from('feeds').select().eq('user_id', userId).order('created_at', ascending: false);
    return (data as List).map((e) => FeedMapper.toDomain(FeedDto.fromJson(e))).toList();
  }

  @override
  Future<List<FeedModel>> getFriendFeeds(String userId, {int limit = 20, DateTime? before}) async {
    // RLS가 적용되면 본인이 참여한 친구 관계만 조회 가능하도록 정책 설정 필요
    final friendsData = await client.from('friends').select('user_a_id, user_b_id').or('user_a_id.eq.$userId,user_b_id.eq.$userId');
    final friendIds = (friendsData as List).map((e) => e['user_a_id'] == userId ? e['user_b_id'] : e['user_a_id']).toList();
    friendIds.add(userId);

    var query = client.from('feeds').select().filter('user_id', 'in', friendIds);
    if (before != null) {
      query = query.lt('created_at', before.toIso8601String());
    }
    final data = await query.order('created_at', ascending: false).limit(limit);
    return (data as List).map((e) => FeedMapper.toDomain(FeedDto.fromJson(e))).toList();
  }

  @override
  Future<void> updateFeed(FeedModel feed) async {
    final dto = FeedMapper.toDto(feed);
    await client.from('feeds').update(dto.toJson()).eq('id', feed.id);
  }

  @override
  Future<void> deleteFeed(String id) async {
    await client.from('feeds').delete().eq('id', id);
  }
}
