import 'package:catdog/data/dto/follow_request_dto.dart';
import 'package:catdog/data/mapper/follow_request_mapper.dart';
import 'package:catdog/domain/model/follow_request_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FollowRequestRepositoryImpl implements FollowRequestRepository {
  FollowRequestRepositoryImpl(this._client);
  final SupabaseClient _client;
  @override
  Future<bool> sendFollowRequest(String friendId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      final uuid = const Uuid();
      final followRequest = FollowRequestModel(
        id: uuid.v4(),
        fromUserId: myId,
        toUserId: friendId,
        status: 'PENDING',
        type: 'FRIEND',
      );
      final dto = FollowRequestMapper.toDto(followRequest);
      try {
        await _client.from('follow_requests').upsert(dto.toJson());
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  @override
  Future<bool> rejectFollowRequest(String friendId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      try {
        await _client
            .from('follow_requests')
            .update({'status': 'REJECTED'})
            .eq('from_user_id', friendId)
            .eq('to_user_id', myId);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  @override
  Future<List<FollowRequestModel>> getAllFollowRequest() async {
    final userId = _client.auth.currentUser?.id;
    if (userId != null) {
      final response1 = await _client
          .from('follow_requests')
          .select()
          .eq('to_user_id', userId);

      final result1 = response1
          .map(
            (json) =>
                FollowRequestMapper.toDomain(FollowRequestDto.fromJson(json)),
          )
          .toList();

      return result1;
    }
    return [];
  }

  @override
  Future<bool> updateFollowRequest(String friendId, String type) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      try {
        await _client
            .from('follow_requests')
            .update({'type': type})
            .eq('from_user_id', friendId)
            .eq('to_user_id', myId);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  @override
  Future<bool> acceptFollowRequest(String friendId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      try {
        await _client
            .from('follow_requests')
            .update({'status': 'ACCEPTED'})
            .eq('from_user_id', friendId)
            .eq('to_user_id', myId);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
