import 'dart:async';
import 'dart:io';

import 'package:catdog/domain/repository/fcm_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmRepositoryImpl implements FcmRepository {
  final FirebaseMessaging _messaging;
  final SupabaseClient _supabase;

  FcmRepositoryImpl(this._messaging, this._supabase);

  @override
  Future<void> initPermission() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission();
      String? apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 2));
        await _messaging.getAPNSToken();
      }
    } else {
      await _messaging.requestPermission();
    }
  }

  @override
  Future<String?> getToken() {
    return _messaging.getToken();
  }

  @override
  Stream<String> onTokenRefresh() {
    return _messaging.onTokenRefresh;
  }

  @override
  Future<void> saveToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    debugPrint('FCM TOKEN: $token');

    await _supabase.from('fcm_tokens').upsert({
      'user_id': userId,
      'token': token,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
    }, onConflict: 'user_id');
  }

  @override
  Future<void> removeToken() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('fcm_tokens')
        .update({'token': null})
        .eq('user_id', userId);
  }
}
