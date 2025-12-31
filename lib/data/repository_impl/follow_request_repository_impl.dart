import 'dart:async';
import 'dart:io';

import 'package:catdog/data/dto/follow_request_dto.dart';
import 'package:catdog/data/mapper/follow_request_mapper.dart';
import 'package:catdog/domain/model/follow_request_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FollowRequestRepositoryImpl implements FollowRequestRepository {
  FollowRequestRepositoryImpl(this._client);
  final SupabaseClient _client;
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
        await _client.from('follow_requests').upsert(dto.toJson());
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

  // 로그인시 db 토큰 테이블에 업데이트
  @override
  StreamSubscription<dynamic>? authSubscribe() {
    return _client.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          final userId = _client.auth.currentUser?.id;
          print("토큰!!!!! : $fcmToken");
          if (userId != null) {
            await _client.from('fcm_tokens').upsert({
              'user_id': userId,
              'token': fcmToken,
              'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
            }, onConflict: 'user_id, token');
          }
        }
      }
    });
  }

  // 앱 사용중 토큰 변경시 db에 업데이트
  @override
  StreamSubscription<dynamic>? tokenSubscribe() {
    return FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        await _client.from('fcm_tokens').upsert({
          'user_id': userId,
          'token': fcmToken,
          'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
        }, onConflict: 'user_id, token');
      }
    });
  }
}
