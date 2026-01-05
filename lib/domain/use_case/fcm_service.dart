import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
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
    debugPrint("!!!!!토큰!!!!!! : $token");
    await _supabase.from('fcm_tokens').upsert({
      'user_id': userId,
      'token': token,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
    }, onConflict: 'user_id'); // user_id만 있게 바꿔야함!!
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
