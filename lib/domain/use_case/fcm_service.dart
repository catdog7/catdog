import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmService {
  FcmService._(this._supabase);
  static FcmService? _instance;

  final SupabaseClient _supabase;

  StreamSubscription<String>? _tokenSub;
  StreamSubscription<AuthState>? _authSub;
  bool _initialized = false;

  /// 최초 1회만 생성
  static FcmService instance(SupabaseClient supabase) {
    return _instance ??= FcmService._(supabase);
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (Platform.isIOS) {
      // APNs 토큰 확인
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(Duration(seconds: 2)); // 잠시 대기
        apnsToken = await messaging.getAPNSToken();
      }
    }

    //앱 시작 시 현재 FCM 토큰 저장
    final token = await messaging.getToken();
    if (token != null) {
      await _saveToken(token);
    }

    //FCM 토큰 변경 감지
    _tokenSub = messaging.onTokenRefresh.listen(_saveToken);

    //Supabase Auth 상태 변경 감지
    _authSub = _supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        final token = await messaging.getToken();
        if (token != null) {
          await _saveToken(token);
        }
      }

      if (event.event == AuthChangeEvent.signedOut) {
        // 선택: 로그아웃 시 토큰 제거
        await _removeToken();
      }
    });
  }

  Future<void> _saveToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      // 현재 이 유저-토큰 조합이 이미 있는지 확인
      final existing = await _supabase
          .from('fcm_tokens')
          .select()
          .eq('user_id', userId)
          .eq('token', token)
          .maybeSingle();

      final String now = DateTime.now().toUtc().toIso8601String();

      if (existing != null) {
        // 이미 있다면 마지막 활동 시간 갱신
        await _supabase
            .from('fcm_tokens')
            .update({'created_at': now})
            .eq('id', existing['id']);
        print('기존 토큰 시간 갱신 완료');
      } else {
        //새로운 기기/계정 접속인 경우 개수 확인
        final List<dynamic> tokens = await _supabase
            .from('fcm_tokens')
            .select('id, created_at')
            .eq('user_id', userId)
            .order('created_at', ascending: true); // 가장 오래된 것이 위로

        const int maxSlots = 3;

        if (tokens.length >= maxSlots) {
          //꽉 찼다면 가장 오래된(created_at이 가장 작은) 행을 업데이트
          final String oldestId = tokens[0]['id'].toString();
          await _supabase
              .from('fcm_tokens')
              .update({
                'token': token,
                'platform': Platform.isIOS ? "IOS" : "ANDROID",
                'created_at': now,
              })
              .eq('id', oldestId);
          print('오래된 토큰 슬롯 교체 완료');
        } else {
          //여유가 있다면 새로 추가
          await _supabase.from('fcm_tokens').insert({
            'user_id': userId,
            'token': token,
            'platform': Platform.isIOS ? "IOS" : "ANDROID",
            'created_at': now,
          });
          print('새 토큰 등록 완료');
        }
      }
    } catch (e) {
      print('Token Sync Error: $e');
    }
  }

  // 로그아웃 시 토큰 삭제
  Future<void> _removeToken() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await _supabase
        .from('fcm_tokens')
        .update({'token': null})
        .eq('user_id', userId);
  }

  void dispose() {
    _tokenSub?.cancel();
    _authSub?.cancel();
  }
}
