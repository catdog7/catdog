import 'dart:async';
import 'dart:io';

import 'package:catdog/domain/repository/fcm_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
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

    try {
      final messaging = FirebaseMessaging.instance;

      // iOS
      try {
        await messaging.requestPermission();
      } catch (e, s) {
        debugPrint('FCM requestPermission error: $e');
        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
      }

      // 토큰 갱신 리스너
      try {
        _tokenSub = messaging.onTokenRefresh.listen(
          (token) async {
            try {
              await _saveToken(token);
            } catch (e, s) {
              debugPrint('FCM saveToken error: $e');
              FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
            }
          },
          onError: (e, s) {
            debugPrint('FCM onTokenRefresh stream error: $e');
            FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
          },
        );
      } catch (e, s) {
        debugPrint('FCM onTokenRefresh listen error: $e');
        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
      }

      // Auth 상태 변경 리스너
      _authSub = _supabase.auth.onAuthStateChange.listen(
        (event) async {
          try {
            if (event.event == AuthChangeEvent.signedIn) {
              await _checkAndRegistrationToken();
            }

            if (event.event == AuthChangeEvent.signedOut) {
              await _removeToken();
            }
          } catch (e, s) {
            debugPrint('AuthStateChange handling error: $e');
            FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
          }
        },
        onError: (e, s) {
          debugPrint('AuthStateChange stream error: $e');
          FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
        },
      );

      // 이미 로그인 상태인 경우
      if (_supabase.auth.currentUser != null) {
        try {
          await _checkAndRegistrationToken();
        } catch (e, s) {
          debugPrint('Initial token registration error: $e');
          FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
        }
      }
    } catch (e, s) {
      debugPrint('FCM init fatal error (blocked): $e');
      FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
    }
  }

  /// 토큰 등록이 필요한지 확인하고 등록하는 함수
  Future<void> _checkAndRegistrationToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isRegistered = prefs.getBool('fcm_registered') ?? false;

      if (isRegistered && _supabase.auth.currentUser != null) {
        return;
      }

      final messaging = FirebaseMessaging.instance;

      // 안드로이드/iOS 서비스 안정화를 위해 미세한 지연 시간 부여
      await Future.delayed(const Duration(milliseconds: 500));

      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await messaging.getAPNSToken();
        }
      }

      // 핵심 수정: getToken을 try-catch로 보호
      final token = await messaging.getToken();

      if (token != null) {
        await _saveToken(token);
        await prefs.setBool('fcm_registered', true);
      }
    } on FirebaseException catch (e) {
      // Firebase 관련 에러 처리
      print("FCM Token 발급 실패 (FirebaseException): ${e.code} - ${e.message}");
    } catch (e) {
      // 일반적인 입출력 에러 처리
      print("FCM Token 발급 중 알 수 없는 에러 발생: $e");
    }
  }

  Future<void> _saveToken(String token) async {
    try {
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
    } catch (e, s) {
      debugPrint('_saveToken failed: $e');
      FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
    }
  }

  Future<void> _removeToken() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('fcm_tokens')
          .update({'token': null})
          .eq('user_id', userId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fcm_registered');
    } catch (e, s) {
      debugPrint('_removeToken failed: $e');
      FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
    }
  }

  @override
  void dispose() {
    _tokenSub?.cancel();
    _authSub?.cancel();
  }
}
