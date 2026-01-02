import 'dart:async';
import 'package:catdog/data/dto/follow_request_dto.dart';
import 'package:catdog/data/mapper/follow_request_mapper.dart';
import 'package:catdog/domain/model/follow_request_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FollowRequestRepositoryImpl implements FollowRequestRepository {
  FollowRequestRepositoryImpl(this._client);
  final SupabaseClient _client;

  // 친구요청테이블에 없을때 추가
  // 이미 있다면 ACCEPTED가 아니면 업데이트 -> to_user_id만 업데이트 가능해서 고민중
  // @override
  // Future<String> sendFollowRequest(String friendId) async {
  //   final myId = _client.auth.currentUser?.id;
  //   if (myId != null) {
  //     try {
  //       final response = await _client
  //           .from('follow_requests')
  //           .select()
  //           .eq('from_user_id', myId)
  //           .eq('to_user_id', friendId);

  //       final result = response
  //           .map(
  //             (json) =>
  //                 FollowRequestMapper.toDomain(FollowRequestDto.fromJson(json)),
  //           )
  //           .toList();

  //       if (result.isEmpty) {
  //         print("친구 요청 테이블에 없음");
  //         final uuid = const Uuid();
  //         final followRequest = FollowRequestModel(
  //           id: uuid.v4(),
  //           fromUserId: myId,
  //           toUserId: friendId,
  //         );
  //         final dto = FollowRequestMapper.toDto(followRequest);
  //         await _client.from('follow_requests').insert(dto.toJson());
  //         return "SUCCESS";
  //       }

  //       if (result.first.status == "ACCEPTED") {
  //         return "FRIEND";
  //       } else {
  //         print("ACCEPTED 아님");
  //       }

  //       await _client
  //           .from('follow_requests')
  //           .update({'status': 'PENDING'})
  //           .eq('from_user_id', myId)
  //           .eq('to_user_id', friendId);

  //       return "SUCCESS";
  //     } catch (e) {
  //       return "FAIL";
  //     }
  //   }
  //   print("유저 id 없음");
  //   return "FAIL";
  // }

  // 친구테이블에 없으면(아직 친구가 아니면) 친구 요청 테이블에 추가
  // 친구가 아니면 중복으로 요청이 가능하고 수락했을 때도 중복으로 수락 알림이 감
  @override
  Future<String> sendFollowRequest(String friendId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId != null) {
      if (myId.compareTo(friendId) < 0) {
        final response = await _client
            .from('friends')
            .select()
            .eq('user_a_id', myId)
            .eq('user_b_id', friendId);
        if (response.isNotEmpty) {
          return "FRIEND";
        }
      } else {
        final response = await _client
            .from('friends')
            .select()
            .eq('user_a_id', friendId)
            .eq('user_b_id', myId);
        if (response.isNotEmpty) {
          return "FRIEND";
        }
      }

      final uuid = const Uuid();
      final followRequest = FollowRequestModel(
        id: uuid.v4(),
        fromUserId: myId,
        toUserId: friendId,
      );
      final dto = FollowRequestMapper.toDto(followRequest);
      try {
        await _client.from('follow_requests').insert(dto.toJson());
        // _client.from('follow_requests').upsert({
        //   'from_user_id': myId,
        //   'to_user_id': friendId,
        //   'status': 'PENDING',
        // }, onConflict: 'from_user_id, to_user_id');
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
