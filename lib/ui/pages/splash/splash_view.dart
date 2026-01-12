import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/login/nickname_view.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    try {
      await Future.wait([
        precacheImage(const AssetImage('assets/images/splash/splash_bg.png'), context),
        precacheImage(const AssetImage('assets/images/splash/splash_cat.webp'), context),
        precacheImage(const AssetImage('assets/images/splash/title.png'), context),
        precacheImage(const AssetImage('assets/images/splash/title_small.png'), context),
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
      final client = ref.read(supabaseClientProvider);
      final useCase = ref.read(userUseCaseProvider);

      await Future.delayed(const Duration(milliseconds: 2000));

      final session = client.auth.currentSession;

      if (!mounted) return;

      if (session == null) {
        _navigate(const LoginView());
        return;
      }

      final hasNickname = await useCase.hasNickname(session.user.id);

      if (!mounted) return;

      if (!hasNickname) {
        _navigate(const NicknameView());
      } else {
        _navigate(const HomeView());
      }
    } catch (_) {
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

  ImageFrameBuilder _createFrameBuilder(bool Function() isLoaded, void Function() setLoaded) {
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
