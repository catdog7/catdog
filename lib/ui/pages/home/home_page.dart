import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/ui/pages/login/login_page.dart';
import 'package:catdog/ui/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  late Future<String?> _nicknameFuture;

  @override
  void initState() {
    super.initState();
    print('HomePage: initState called');
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage: Building...');
    final client = ref.read(supabaseClientProvider);
    final user = client.auth.currentUser;
    final email = user?.email ?? 'Unknown User';

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
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
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
      body: const Center(
        child: Text(
          'Home Screen Content',
          style: TextStyle(fontSize: 24, color: Colors.black54),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onWritePressed: () => print('Write button tapped'),
      ),
    );
  }
}

// Note: To achieve the "two and two between write button circle" look, 
// we use a BottomAppBar with a FloatingActionButtonLocation.centerDocked.
// I will adjust the Scaffold to use centerDocked for the Write button.
