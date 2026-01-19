import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/core/service/widget_service.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/login/nickname_view.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  bool _isInitialized = false;
  bool _bgLoaded = false;
  bool _catLoaded = false;
  bool _titleLoaded = false;
  bool _titleSmallLoaded = false;

  @override
  void initState() {
    super.initState();

    // 앱이 켜지고 스플래시 위젯이 생성시 기록
    _logSplashEntry();
  }

  // 로그 기록용 별도 함수
  void _logSplashEntry() {
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Splash_View',
      screenClass: 'SplashView',
    );
    FirebaseAnalytics.instance.logEvent(name: 'app_open_start');
    debugPrint('Analytics: Splash_View 기록');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    try {
      await Future.wait([
        precacheImage(
          const AssetImage('assets/images/splash/splash_bg.png'),
          context,
        ),
        precacheImage(
          const AssetImage('assets/images/splash/splash_cat.webp'),
          context,
        ),
        precacheImage(
          const AssetImage('assets/images/splash/title.png'),
          context,
        ),
        precacheImage(
          const AssetImage('assets/images/splash/title_small.png'),
          context,
        ),
      ]);

      if (mounted) {
        setState(() {
          _bgLoaded = true;
          _catLoaded = true;
          _titleLoaded = true;
          _titleSmallLoaded = true;
        });

        if (!_isInitialized) {
          _isInitialized = true;
          _runInit();
        }
      }
    } catch (e) {
      print('Image preload error: $e');
      if (mounted && !_isInitialized) {
        _isInitialized = true;
        _runInit();
      }
    }
  }

  Future<void> _runInit() async {
    try {
      // 1. 위젯 실행 여부 먼저 확인 (딜레이 없이 즉시 반응하기 위함)
      String? widgetDeepLink;
      try {
        final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
        debugPrint('SplashView: initialUri from home_widget = $initialUri');
        
        if (initialUri != null && initialUri.toString().startsWith('catdog-widget://')) {
          widgetDeepLink = initialUri.toString();
          debugPrint('SplashView: widgetDeepLink confirmed = $widgetDeepLink');
        }
      } catch (e) {
        debugPrint('SplashView: initiallyLaunchedFromHomeWidget error: $e');
      }

      // 2. 위젯으로 실행된 경우가 아니라면, 스플래시 최소 표시 시간 준수
      // (위젯 실행 시에는 사용자가 빠른 진입을 원하므로 딜레이 스킵)
      if (widgetDeepLink == null) {
        await Future.delayed(const Duration(milliseconds: 2000));
      } else {
        debugPrint('SplashView: Widget launch detected. Skipping splash delay.');
      }

      // 3. 세션 확인 및 네비게이션
      final client = ref.read(supabaseClientProvider);
      final useCase = ref.read(userUseCaseProvider);

      final session = client.auth.currentSession;
      
      if (!mounted) return;

      if (session == null) {
        debugPrint('SplashView: Login Check Failed (No Session) -> Navigate to LoginView');
        await FirebaseAnalytics.instance.logEvent(name: 'splash_to_login');
        _navigate(const LoginView());
        return;
      }

      debugPrint('SplashView: Login Check Passed (User ID: ${session.user.id})');
      final hasNickname = await useCase.hasNickname(session.user.id);

      if (!mounted) return;

      if (!hasNickname) {
        debugPrint('SplashView: No Nickname -> Navigate to NicknameView');
        await FirebaseAnalytics.instance.logEvent(name: 'splash_to_nickname');
        _navigate(const NicknameView());
      } else {
        debugPrint('SplashView: All Checks Passed -> Navigate to HomeView (deepLink: $widgetDeepLink)');
        await FirebaseAnalytics.instance.logEvent(name: 'splash_to_home');
        // 위젯 딥링크가 있으면 HomeView에 전달
        _navigate(HomeView(initialDeepLink: widgetDeepLink));
      }
    } catch (e) {
      debugPrint('SplashView._runInit error: $e');
      if (mounted) _navigate(const LoginView());
    }
  }

  void _navigate(Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
      ),
    );
  }

  ImageFrameBuilder _createFrameBuilder(
    bool Function() isLoaded,
    void Function() setLoaded,
  ) {
    return (context, child, frame, wasSynchronouslyLoaded) {
      if (frame != null && !isLoaded()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              setLoaded();
            });
          }
        });
      }
      return child;
    };
  }

  Widget _buildImage({
    required String assetPath,
    required bool isLoaded,
    required void Function() setLoaded,
    required BoxFit fit,
  }) {
    return Image.asset(
      assetPath,
      fit: fit,
      frameBuilder: _createFrameBuilder(() => isLoaded, setLoaded),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildImage(
              assetPath: 'assets/images/splash/splash_bg.png',
              isLoaded: _bgLoaded,
              setLoaded: () => _bgLoaded = true,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: _catLoaded ? 1.0 : 0.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth,
                  child: _buildImage(
                    assetPath: 'assets/images/splash/splash_cat.webp',
                    isLoaded: _catLoaded,
                    setLoaded: () => _catLoaded = true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight * 0.4,
            child: Opacity(
              opacity: _titleLoaded ? 1.0 : 0.0,
              child: Center(
                child: SizedBox(
                  width: screenWidth * 0.6,
                  child: _buildImage(
                    assetPath: 'assets/images/splash/title.png',
                    isLoaded: _titleLoaded,
                    setLoaded: () => _titleLoaded = true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight * 0.4 + 80.0,
            child: Opacity(
              opacity: _titleSmallLoaded ? 1.0 : 0.0,
              child: Center(
                child: SizedBox(
                  width: screenWidth * 0.5,
                  child: _buildImage(
                    assetPath: 'assets/images/splash/title_small.png',
                    isLoaded: _titleSmallLoaded,
                    setLoaded: () => _titleSmallLoaded = true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
