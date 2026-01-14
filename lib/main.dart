import 'dart:async';
import 'dart:ui';
import 'package:catdog/core/config/fcm_dependency.dart';
import 'package:catdog/core/utils/app_keys.dart';
import 'package:catdog/firebase_options.dart';
import 'package:catdog/ui/pages/friend/state/fcm_event.dart';
import 'package:catdog/ui/pages/splash/splash_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await FirebaseAnalytics.instance.logEvent(
    name: 'notification_receive_bg',
    parameters: {
      'message_id': message.messageId?.toString() ?? 'unknown',
      'title': message.notification?.title ?? 'no_title',
      'type': message.data['type'] ?? 'default',
    },
  );
  debugPrint('백그라운드 FCM 메시지 수신 및 로그 기록 완료');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  //Flutter 프레임워크에서 처리하지 않는 비동기 오류를 포착
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<FcmEvent>? _sub;
  @override
  void initState() {
    super.initState();
    // FCM 초기화
    Future.microtask(() {
      ref.read(fcmBootstrapProvider);
    });

    // 전역 FCM 이벤트 구독 (UI 처리)
    _sub = ref.read(fcmEventStreamProvider.stream).listen((event) {
      final message = switch (event.type) {
        FcmEventType.friendRequest => '님이 친구를 요청 했습니다.',
        FcmEventType.friendAccepted => '님이 친구 요청을 수락 했습니다.',
      };

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF575E6A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '${event.who ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(message),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatDog',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ], //페이지 전환 추적
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어 설정
      ],
      locale: const Locale('ko', 'KR'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      // 딥링크 처리 시 Flutter Navigator가 해당 경로를 찾지 못해 발생하는 에러 방지
      onGenerateRoute: (settings) {
        // Supabase OAuth 콜백 등 딥링크 경로는 여기서 처리하지 않고 무시함
        return MaterialPageRoute(
          builder: (_) => const SizedBox.shrink(),
          settings: settings,
        );
      },
      home: const SplashView(),
    );
  }
}
