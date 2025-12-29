import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  late Future<String?> _nicknameFuture;

  @override
  void initState() {
    super.initState();
    _nicknameFuture = _fetchNickname();
  }

  Future<String?> _fetchNickname() async {
    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) return null;
      final response = await client
          .from('users')
          .select('nickname')
          .eq('id', userId)
          .maybeSingle();
      return response?['nickname'] as String?;
    } catch (e) {
      print('Error fetching nickname: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    final email = user?.email ?? 'Unknown User';
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: FutureBuilder<String?>(
          future: _nicknameFuture,
          builder: (context, snapshot) {
            final nickname = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nickname ?? 'Loading...',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenWidth * 0.043, // 16/375 ≈ 0.043
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth * 0.032, // 12/375 ≈ 0.032
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await ref.read(supabaseClientProvider).auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.053), // 20/375 ≈ 0.053
            child: Text(
              '홈 화면',
              style: TextStyle(
                fontSize: screenWidth * 0.064, // 24/375 ≈ 0.064
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

