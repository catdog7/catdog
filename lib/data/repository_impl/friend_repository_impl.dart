import 'package:catdog/data/dto/friend_dto.dart';
import 'package:catdog/data/mapper/friend_mapper.dart';
import 'package:catdog/domain/model/friend_model.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<bool> addFriend(FriendModel friend) async {
    try {
      final dto = FriendMapper.toDto(friend);
      await _client.from('friends').insert(dto.toJson());
      return true;
    } catch (e) {
      print("친구테이블에 추가 실패");
      return false;
    }
  }

  @override
  Future<bool> deleteFriend(String userAID, String userBID) async {
    try {
      //user A의 Id와 user B의 Id 순서 비교
      if (userAID.compareTo(userBID) < 0) {
        await _client
            .from('friends')
            .delete()
            .eq('user_a_id', userAID)
            .eq('user_b_id', userBID);
      } else {
        await _client
            .from('friends')
            .delete()
            .eq('user_a_id', userBID)
            .eq('user_b_id', userAID);
      }
      return true;
    } catch (e) {
      print("친구테이블에서 삭제 실패");
      return false;
    }
  }

  @override
  Future<List<FriendModel>> getAllFriends(String userId) async {
    //유저의 id가 'user_a_id'에 있는 경우
    final response1 = await _client
        .from('friends')
        .select()
        .eq('user_a_id', userId);

    final result1 = response1
        .map((json) => FriendMapper.toDomain(FriendDto.fromJson(json)))
        .toList();

    //유저의 id가 'user_b_id'에 있는 경우
    final response2 = await _client
        .from('friends')
        .select()
        .eq('user_b_id', userId);

    final result2 = response2
        .map((json) => FriendMapper.toDomain(FriendDto.fromJson(json)))
        .toList();

    return [...result1, ...result2];
  }
}
