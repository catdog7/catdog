import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/home/view/pet_register_view.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadPets();
    }
  }

  Future<void> _loadPets() async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      ref.read(showModalProvider.notifier).state = false;
      return;
    }

    try {
      // 동물 존재 여부만 확인 (더 효율적)
      final hasPets = await ref.read(petUseCaseProvider).hasPets(userId);
      print('hasPets: $hasPets, userId: $userId');
      ref.read(showModalProvider.notifier).state = !hasPets;
    } catch (e) {
      print('_loadPets error: $e');
      ref.read(showModalProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final showModal = ref.watch(showModalProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '홈',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.54,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: showModal
                ? null
                : () async {
                    final client = ref.read(supabaseClientProvider);
                    await client.auth.signOut();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    }
                  },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '홈 화면',
          style: TextStyle(fontSize: 24, color: Colors.black54),
        ),
      ),
    );
  }
}

