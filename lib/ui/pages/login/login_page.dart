import 'dart:async';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/ui/pages/home/home_page.dart';
import 'package:catdog/ui/pages/login/nickname_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final SupabaseClient client;
  final uuid = const Uuid();
  String status = 'Ready to test';
  bool _isNavigating = false;
  bool _isLoading = false;

  // Controllers for manual input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    client = ref.read(supabaseClientProvider);
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        final session = data.session;
        if (session != null) {
          setState(() {
            status = 'Logged in as ${session.user.email}';
          });
          // Check nickname and navigate
          _handlePostLoginNavigation(session.user.id);
        } else {
          setState(() {
            status = 'Signed Out.';
          });
        }
      }
    });
  }

  Future<void> _handlePostLoginNavigation(String userId) async {
    if (_isNavigating) return;
    setState(() => _isLoading = true);
    _isNavigating = true;

    try {
      print('LoginPage: Handling Post-Login for $userId');
      final response = await client
          .from('users')
          .select('nickname')
          .eq('id', userId)
          .maybeSingle();

      print('LoginPage: Nickname Check Result: $response');

      Widget targetPage;
      if (response == null || response['nickname'] == null || (response['nickname'] as String).isEmpty) {
        print('LoginPage: Navigating to NicknamePage');
        targetPage = const NicknamePage();
      } else {
        print('LoginPage: Navigating to HomePage');
        targetPage = const HomePage();
      }

      if (mounted) {
        print('LoginPage: Executing Navigator.pushAndRemoveUntil to ${targetPage.runtimeType}');
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void updateStatus(String msg) {
    setState(() {
      status = msg;
    });
    print(msg);
  }


  // Manual Sign In
  Future<void> testSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return updateStatus('Enter email and password first!');
    }

    try {
      setState(() => _isLoading = true);
      updateStatus('Attempting Manual SignIn: $email');
      final res = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user != null) {
        updateStatus('Success! User Signed In: ${res.user!.id}');
      }
    } catch (e) {
      updateStatus('SignIn Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> testGoogleLogin() async {
    try {
      setState(() => _isLoading = true);
      updateStatus('Starting Google Login (OAuth)...');
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.catdog://login-callback/',
      );
    } catch (e) {
      updateStatus('Google Login Error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> testSignOut() async {
    await client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CatDog Login Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text('Status: $status', style: const TextStyle(fontSize: 13)),
            ),
            const SizedBox(height: 20),
            
            // Manual Input Section
            const Text('Manual Login', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : testSignIn, 
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Sign In')
            ),
            const Divider(height: 40),

            ElevatedButton(
              onPressed: _isLoading ? null : testGoogleLogin, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
              child: const Text('구글 로그인 테스트 (OAuth)')
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : testSignOut, 
              child: const Text('로그아웃 (초기화)')
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
