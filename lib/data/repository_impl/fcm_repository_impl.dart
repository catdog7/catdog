import 'dart:async';
import 'dart:io';

import 'package:catdog/domain/repository/fcm_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmRepositoryImpl implements FcmRepository {
  FcmRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  StreamSubscription<String>? _tokenSub;
  StreamSubscription<AuthState>? _authSub;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    _tokenSub = messaging.onTokenRefresh.listen(_saveToken);

    _authSub = _supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await _checkAndRegistrationToken();
      }

      if (event.event == AuthChangeEvent.signedOut) {
        await _removeToken();
      }
    });

    if (_supabase.auth.currentUser != null) {
      await _checkAndRegistrationToken();
    }
  }

  /// 토큰 등록이 필요한지 확인하고 등록하는 함수
  Future<void> _checkAndRegistrationToken() async {
    final prefs = await SharedPreferences.getInstance();
    // 'fcm_registered' 키가 없으면 처음 실행으로 간주
    bool isRegistered = prefs.getBool('fcm_registered') ?? false;

    if (isRegistered && _supabase.auth.currentUser != null) {
      return; // 이미 등록됨 + 로그인 상태 유지 중이면 종료
    }

    final messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      // APNs 토큰 확인
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(Duration(seconds: 2)); // 잠시 대기
        apnsToken = await messaging.getAPNSToken();
      }
    }
    final token = await messaging.getToken();
    if (token != null) {
      await _saveToken(token);
      // 등록 성공 후 플래그 저장
      await prefs.setBool('fcm_registered', true);
    }
  }

  Future<void> _saveToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final now = DateTime.now().toUtc().toIso8601String();

    final existing = await _supabase
        .from('fcm_tokens')
        .select()
        .eq('user_id', userId)
        .eq('token', token)
        .maybeSingle();

    if (existing != null) {
      await _supabase
          .from('fcm_tokens')
          .update({'created_at': now})
          .eq('id', existing['id']);
      return;
    }

    final tokens = await _supabase
        .from('fcm_tokens')
        .select('id, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    const maxSlots = 3;

    if (tokens.length >= maxSlots) {
      await _supabase
          .from('fcm_tokens')
          .update({
            'token': token,
            'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
            'created_at': now,
          })
          .eq('id', tokens.first['id']);
    } else {
      await _supabase.from('fcm_tokens').insert({
        'user_id': userId,
        'token': token,
        'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
        'created_at': now,
      });
    }
  }

  Future<void> _removeToken() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('fcm_tokens')
        .update({'token': null})
        .eq('user_id', userId);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_registered');
  }

  @override
  void dispose() {
    _tokenSub?.cancel();
    _authSub?.cancel();
  }
}
