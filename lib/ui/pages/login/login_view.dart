import 'dart:async';
import 'dart:convert';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/login/login_view1.dart';
import 'package:catdog/ui/pages/login/nickname_view.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final SupabaseClient client;
  bool _isLoading = false;
  bool _isNavigating = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    client = ref.read(supabaseClientProvider);

    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && !_isNavigating) {
        _handlePostLoginNavigation(session.user.id);
      } else {
        // 세션이 없거나 에러 상황일 때 로딩을 풀어줌
        if (mounted) setState(() => _isLoading = false);
      }
    }, onError: (error) {
      // 에러 발생 시 처리
      if (mounted) setState(() => _isLoading = false);
      debugPrint('Auth State Error: $error');
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handlePostLoginNavigation(String userId) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final useCase = ref.read(userUseCaseProvider);
      final hasNickname = await useCase.hasNickname(userId);

      if (!mounted) {
        _isNavigating = false;
        return;
      }

      final targetPage =
          hasNickname ? const HomeView() : const NicknameView();

      // 로딩 상태 한 번 더 해제 (네비게이션 직전)
      setState(() => _isLoading = false);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => targetPage),
        (_) => false,
      );
    } catch (e) {
      debugPrint('Login navigation error: $e');
      _isNavigating = false;
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeView()),
          (_) => false,
        );
      }
    }
  }

  Future<void> _googleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isNavigating = false; // 네비게이션 상태 초기화
    });

    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.catdog://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
        queryParams: {
          'prompt': 'select_account',
        },
      );
      
      // OAuth 로그인은 비동기로 앱으로 돌아오며 onAuthStateChange가 트리거됩니다.
      // 사용자가 브라우저를 수동으로 닫을 경우 로딩 상태가 계속 유지될 수 있으므로,
      // 탭을 다시 눌렀을 때 로딩이 풀리도록 로직을 구성했습니다.
    } catch (e) {
      debugPrint('Google login error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _appleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isNavigating = false; // 네비게이션 상태 초기화
    });

    try {
      // iOS/macOS에서는 네이티브 Sign in with Apple 사용
      if (!kIsWeb && (Theme.of(context).platform == TargetPlatform.iOS || 
                      Theme.of(context).platform == TargetPlatform.macOS)) {
        await _appleLoginNative();
      } else {
        // Android, Web, Windows, Linux에서는 OAuth 방식 사용
        await client.auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: kIsWeb ? null : 'io.supabase.catdog://login-callback',
          authScreenLaunchMode: kIsWeb 
              ? LaunchMode.platformDefault 
              : LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Apple login error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// iOS/macOS 네이티브 Sign in with Apple
  Future<void> _appleLoginNative() async {
    try {
      // Nonce 생성 및 해싱
      final rawNonce = client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Apple ID 자격 증명 요청
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException(
            'Could not find ID Token from generated credential.');
      }

      // Supabase에 ID Token으로 로그인
      final authResponse = await client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      // Apple은 첫 로그인 시에만 full name을 제공
      // user metadata에 저장
      if (credential.givenName != null || credential.familyName != null) {
        final nameParts = <String>[];
        if (credential.givenName != null) nameParts.add(credential.givenName!);
        if (credential.familyName != null) nameParts.add(credential.familyName!);
        final fullName = nameParts.join(' ');

        await client.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': fullName,
              'given_name': credential.givenName,
              'family_name': credential.familyName,
            },
          ),
        );
      }

      // 로그인 성공 후 네비게이션 처리
      if (authResponse.session != null && 
          authResponse.user != null && 
          !_isNavigating) {
        await _handlePostLoginNavigation(authResponse.user!.id);
      }
    } catch (e) {
      debugPrint('Native Apple login error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // 반응형 이미지 크기 (화면 너비의 60-70%)
    final desImageWidth = screenWidth * 0.64; // 240/375 ≈ 0.64
    final titleImageWidth = screenWidth * 0.693; // 260/375 ≈ 0.693

    // 반응형 패딩
    final horizontalPadding = screenWidth * 0.053; // 20/375 ≈ 0.053
    final termsPadding = screenWidth * 0.099; // 37/375 ≈ 0.099

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginView1()),
          );
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.bug_report, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;

            return Column(
              children: [
                // 상단 콘텐츠 영역 (Expanded로 남은 공간 차지)
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          SizedBox(height: availableHeight * 0.2), // 상단 여백 증가

                          // 부제목 이미지
                          Image.asset(
                            'assets/images/des.webp',
                            width: desImageWidth,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: availableHeight * 0.02), // 간격 증가

                          // 타이틀 이미지
                          Image.asset(
                            'assets/images/title.webp',
                            width: titleImageWidth,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: availableHeight * 0.12), // 간격 증가

                          // 구글 로그인 버튼
                          GestureDetector(
                            onTap: _isLoading ? null : _googleLogin,
                            child: Image.asset(
                              'assets/images/google.webp',
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: availableHeight * 0.025), // 간격 증가

                          // 애플 로그인 버튼
                          GestureDetector(
                            onTap: _isLoading ? null : _appleLogin,
                            child: Image.asset(
                              'assets/images/ios.webp',
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 약관 동의 텍스트 (항상 맨 아래 고정)
                Padding(
                  padding: EdgeInsets.only(
                    left: termsPadding,
                    right: termsPadding,
                    bottom: safeAreaBottom > 0 ? safeAreaBottom + screenHeight * 0.02 : screenHeight * 0.02,
                  ),
                  child: Text(
                    '회원가입 시 댕냥댕냥 서비스의\n개인정보처리방침 및 이용약관에 동의한 것으로 간주합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.30),
                      fontSize: screenWidth * 0.035, // 13/375 ≈ 0.035
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.54,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

