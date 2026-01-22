import 'dart:async';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/login/nickname_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LoginView1 extends ConsumerStatefulWidget {
  const LoginView1({super.key});

  @override
  ConsumerState<LoginView1> createState() => _LoginView1State();
}

class _LoginView1State extends ConsumerState<LoginView1> {
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
      print('LoginPage1: Handling Post-Login for $userId');
      final useCase = ref.read(userUseCaseProvider);
      final hasNickname = await useCase.hasNickname(userId);

      print('LoginPage1: Has Nickname: $hasNickname');

      Widget targetPage;
      if (!hasNickname) {
        print('LoginView1: Navigating to NicknameView');
        targetPage = const NicknameView();
      } else {
        print('LoginPage1: Navigating to HomeView');
        targetPage = const HomeView();
      }

      if (mounted) {
        print('LoginPage1: Executing Navigator.pushAndRemoveUntil to ${targetPage.runtimeType}');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => targetPage),
          (route) => false,
        );
      }
    } catch (e) {
      print('LoginPage1: Navigation Error: $e');
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeView()),
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

