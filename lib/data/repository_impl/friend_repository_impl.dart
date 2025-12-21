import 'package:catdog/data/dto/friend_dto.dart';
import 'package:catdog/data/mapper/friend_mapper.dart';
import 'package:catdog/domain/model/friend_model.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> addFriend(FriendModel friend) async {
    final dto = FriendMapper.toDto(friend);
    await client.from('friends').insert(dto.toJson());
  }

  @override
  Future<void> removeFriend(String userAId, String userBId) async {
    await client.from('friends').delete().eq('user_a_id', userAId).eq('user_b_id', userBId);
  }

  @override
  Future<List<FriendModel>> getFriends(String userId) async {
    final data = await client.from('friends').select().or('user_a_id.eq.$userId,user_b_id.eq.$userId');
    return (data as List).map((e) => FriendMapper.toDomain(FriendDto.fromJson(e))).toList();
  }

  @override
  Future<bool> isFriend(String userId, String otherId) async {
    final userAId = userId.compareTo(otherId) < 0 ? userId : otherId;
    final userBId = userId.compareTo(otherId) < 0 ? otherId : userId;
    final data = await client.from('friends').select('id').eq('user_a_id', userAId).eq('user_b_id', userBId).maybeSingle();
    return data != null;
  }
}
