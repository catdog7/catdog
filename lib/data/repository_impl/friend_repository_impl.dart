import 'package:catdog/data/dto/friend_dto.dart';
import 'package:catdog/data/dto/user_dto.dart';
import 'package:catdog/data/mapper/friend_mapper.dart';
import 'package:catdog/data/mapper/user_mapper.dart';
import 'package:catdog/domain/model/friend_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<bool> addFriend(String friendId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      const uuid = Uuid();
      if (myId != null) {
        FriendModel friend = FriendModel(
          id: uuid.v4(),
          userAId: myId,
          userBId: myId,
          createdAt: DateTime.now(),
        );
        if (myId.compareTo(friendId) < 0) {
          friend = friend.copyWith(userBId: friendId);
        } else {
          friend = friend.copyWith(userAId: friendId);
        }
        final dto = FriendMapper.toDto(friend);
        await _client.from('friends').insert(dto.toJson());
        return true;
      }
      return false;
    } catch (e) {
      print("친구테이블에 추가 실패");
      return false;
    }
  }

  @override
  Future<bool> deleteFriend(String friendId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      if (myId != null) {
        //user A의 Id와 user B의 Id 순서 비교
        if (myId.compareTo(friendId) < 0) {
          await _client
              .from('friends')
              .delete()
              .eq('user_a_id', myId)
              .eq('user_b_id', friendId);
        } else {
          await _client
              .from('friends')
              .delete()
              .eq('user_a_id', friendId)
              .eq('user_b_id', myId);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("친구테이블에서 삭제 실패");
      return false;
    }
  }

  @override
  Future<(List<FriendModel>, List<FriendModel>)> getAllFriends() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
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

        return (result1, result2);
      }
      print("친구 가져오기 실패");
      return (<FriendModel>[], <FriendModel>[]);
    } catch (e) {
      print("친구 가져오기 실패");
      return (<FriendModel>[], <FriendModel>[]);
    }
  }

  @override
  Future<List<UserModel>> findUsers(String friendId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        final response = await _client
            .from('users')
            .select()
            .or('nickname.ilike.%$friendId%, invite_code.ilike.%$friendId%')
            .neq('id', userId)
            .order('nickname', ascending: true);
        final result = response
            .map((json) => UserMapper.toModel(UserDto.fromJson(json)))
            .toList();
        return result;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  //친구 테이블에 있는지 확인
  @override
  Future<bool> isFriend(String friendId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      if (myId != null) {
        //user A의 Id와 user B의 Id 순서 비교
        if (myId.compareTo(friendId) < 0) {
          final result = await _client
              .from('friends')
              .select()
              .eq('user_a_id', myId)
              .eq('user_b_id', friendId)
              .maybeSingle();
          if (result != null) {
            return true;
          } else {
            return false;
          }
        } else {
          final result = await _client
              .from('friends')
              .select()
              .eq('user_a_id', friendId)
              .eq('user_b_id', myId)
              .maybeSingle();

          if (result != null) {
            return true;
          } else {
            return false;
          }
        }
      }
      print("친구 가져오기 실패");
      return false;
    } catch (e) {
      print("친구 가져오기 실패");
      return false;
    }
  }
}
