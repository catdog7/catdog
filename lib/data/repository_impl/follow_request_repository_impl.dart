import 'dart:async';
import 'package:catdog/data/dto/follow_request_dto.dart';
import 'package:catdog/data/mapper/follow_request_mapper.dart';
import 'package:catdog/domain/model/follow_request_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowRequestRepositoryImpl implements FollowRequestRepository {
  FollowRequestRepositoryImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<String> sendFollowRequest(String friendId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      try {
        //거절이면 삭제 후 추가
        final result = await deleteFollowRequest(friendId);
        await _client.from('follow_requests').upsert({
          'from_user_id': myId,
          'to_user_id': friendId,
        });
        return "SUCCESS";
      } catch (e) {
        return "FAIL";
      }
    }
    return "FAIL";
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

  //내가 받은 요청들 가져오기
  @override
  Future<List<FollowRequestModel>> getAllFollowRequest() async {
    final userId = _client.auth.currentUser?.id;
    if (userId != null) {
      //일단 요청 다 가져오기
      final response1 = await _client
          .from('follow_requests')
          .select()
          .eq('to_user_id', userId)
          .order('created_at');

      final result1 = response1
          .map(
            (json) =>
                FollowRequestMapper.toDomain(FollowRequestDto.fromJson(json)),
          )
          .toList();

      final seenUserIds = <String>{};

      //from_user_id당 하나의 요청만 필터링
      final result2 = result1.where((item) {
        if (seenUserIds.contains(item.fromUserId)) {
          return false;
        }
        seenUserIds.add(item.fromUserId);
        return true;
      }).toList();

      return result2;
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

  @override
  Future<bool> deleteFollowRequest(String friendId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      try {
        await _client
            .from('follow_requests')
            .delete()
            .eq('from_user_id', myId)
            .eq('to_user_id', friendId);
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  //내가 보낸 요청들 가져오기
  @override
  Future<List<FollowRequestModel>> getMyRequests() async {
    final userId = _client.auth.currentUser?.id;
    if (userId != null) {
      final response1 = await _client
          .from('follow_requests')
          .select()
          .eq('from_user_id', userId);

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
  Future<bool> checkFollowPending(String freindId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        final result = await _client
            .from('follow_requests')
            .select()
            .eq('from_user_id', userId)
            .eq('to_user_id', freindId)
            .maybeSingle();
        if (result != null) {
          if (FollowRequestMapper.toDomain(
                FollowRequestDto.fromJson(result),
              ).status ==
              "PENDING") {
            return true;
          }
          return false;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Follow Status Check Fail");
      return false;
    }
  }
}
