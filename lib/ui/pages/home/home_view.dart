import 'package:catdog/ui/pages/feed/view/feed_add_view.dart';
import 'package:catdog/ui/pages/home/widgets/navigation_body.dart';
import 'package:catdog/ui/pages/home/view/pet_register_view.dart';
import 'package:catdog/ui/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// HomeContent의 모달 상태를 공유하기 위한 Provider
final showModalProvider = StateProvider<bool>((ref) => false);

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    final showModal = ref.read(showModalProvider);
    if (showModal) return; // 모달이 떠있으면 탭 무시
    
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showModal = ref.watch(showModalProvider);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 기존 화면 (NavigationBody)
          NavigationBody(selectedIndex: _selectedIndex),

          // 반투명 레이어 (Barrier) - 앱바와 네비게이션바 포함 전체 화면
          if (showModal) ...[
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            // 팝업 카드 (네비게이션바까지 모두 덮음)
            Center(
              child: Container(
                width: screenWidth * 0.893, // 335/375 ≈ 0.893
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 상단 콘텐츠
                    Padding(
                      padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
                      child: Column(
                        children: [
                          // 프로필 이미지
                          Container(
                            width: 65,
                            height: 64,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("https://placehold.co/65x64"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 환영 메시지
                          const SizedBox(
                            width: 295,
                            child: Text(
                              '댕냥댕냥에 온 것을 환영해요! \n키우고 있는 아이들을 등록해주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 하단 버튼
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PetRegisterView(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFDCA40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '등록하기',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onWritePressed: () {
          if (showModal) return; // 모달이 떠있으면 무시
          print('Write button tapped');
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FeedAddView()),
          );
        },
        isDisabled: showModal, // 모달이 떠있으면 네비게이션바 비활성화 효과
      ),
    );
  }
}
