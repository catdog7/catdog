import 'dart:async';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/ui/pages/home/home_page.dart';
import 'package:catdog/ui/pages/login/login_page1.dart';
import 'package:catdog/ui/pages/login/nickname_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final SupabaseClient client;
  bool _isLoading = false;
  bool _isNavigating = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    client = ref.read(supabaseClientProvider);
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        final session = data.session;
        if (session != null) {
          _handlePostLoginNavigation(session.user.id);
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handlePostLoginNavigation(String userId) async {
    if (_isNavigating) return;
    setState(() => _isLoading = true);
    _isNavigating = true;

    try {
      final useCase = ref.read(userUseCaseProvider);
      final hasNickname = await useCase.hasNickname(userId);

      Widget targetPage;
      if (!hasNickname) {
        targetPage = const NicknamePage();
      } else {
        targetPage = const HomePage();
      }

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => targetPage),
          (route) => false,
        );
      }
    } catch (e) {
      print('LoginPage: Navigation Error: $e');
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    if (_isLoading) return; // 이미 로딩 중이면 중복 실행 방지
    
    try {
      setState(() => _isLoading = true);
      
      // 구글 계정 선택 화면을 강제로 표시하기 위해 queryParams 추가
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.catdog://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
        queryParams: {
          'prompt': 'select_account', // 계정 선택 화면 강제 표시
        },
      );
      
      // OAuth 로그인 후 딥링크로 돌아오면 onAuthStateChange가 트리거됨
      // 타임아웃 설정: 10초 후에도 세션이 없으면 로딩 해제
      await Future.delayed(const Duration(seconds: 10));
      
      if (mounted) {
        final session = client.auth.currentSession;
        if (session != null) {
          _handlePostLoginNavigation(session.user.id);
        } else {
          // 세션이 없으면 로딩 해제 (OAuth 취소되었거나 실패)
          setState(() => _isLoading = false);
          _isNavigating = false;
        }
      }
    } catch (e) {
      print('Google Login Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        _isNavigating = false;
      }
    }
  }

  Future<void> _appleLogin() async {
    // TODO: Apple 로그인 구현
    print('Apple login not implemented yet');
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
            MaterialPageRoute(builder: (context) => const LoginPage1()),
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
