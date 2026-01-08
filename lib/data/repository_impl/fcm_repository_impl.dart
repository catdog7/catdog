import 'dart:async';
import 'dart:io';

import 'package:catdog/domain/repository/fcm_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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

    if (Platform.isIOS) {
      await messaging.getAPNSToken();
    }

    final token = await messaging.getToken();
    if (token != null) {
      await _saveToken(token);
    }

    _tokenSub = messaging.onTokenRefresh.listen(_saveToken);

    _authSub = _supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        final token = await messaging.getToken();
        if (token != null) {
          await _saveToken(token);
        }
      }

      if (event.event == AuthChangeEvent.signedOut) {
        await _removeToken();
      }
    });
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
  }

  @override
  void dispose() {
    _tokenSub?.cancel();
    _authSub?.cancel();
  }
}
