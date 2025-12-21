import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/ui/pages/home/home_page.dart';
import 'package:catdog/ui/pages/login/nickname_page.dart';
import 'package:catdog/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final client = ref.read(supabaseClientProvider);
    
    // 세션 복구 또는 딥링크 처리를 위한 짧은 대기
    await Future.delayed(const Duration(milliseconds: 500));
    
    final session = client.auth.currentSession;
    print('Splash Check - Session: ${session?.user.id}');

    if (session == null) {
      print('RootPage: No session found, going to Login Page');
      _navigate(const LoginPage());
      return;
    }

    try {
      final response = await client
          .from('users')
          .select('nickname')
          .eq('id', session.user.id)
          .maybeSingle();

      print('Splash: Nickname Check Result: $response');

      if (response == null || response['nickname'] == null || (response['nickname'] as String).isEmpty) {
        print('Splash: No nickname, going to Nickname Page');
        _navigate(const NicknamePage());
      } else {
        print('Splash: Has nickname, going to Home Page');
        _navigate(const HomePage());
      }
    } catch (e) {
      print('RootPage Error: $e');
      _navigate(const LoginPage());
    }
  }

  void _navigate(Widget page) {
    if (mounted) {
      print('Splash: Navigating to ${page.runtimeType}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              '로그인 정보 확인 중...',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
