import 'package:catdog/ui/pages/feed/view/feed_add_view.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:catdog/ui/pages/home/widgets/navigation_body.dart';
import 'package:catdog/ui/pages/home/view/pet_register_view.dart';
import 'package:catdog/ui/widgets/main_navigation_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showModalProvider = StateProvider<bool>((ref) => false);

class HomeView extends ConsumerStatefulWidget {
  final int initialIndex;

  const HomeView({super.key, this.initialIndex = 1});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late int _selectedIndex;
  int _homeContentKey = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    // 앱 진입 시 첫 화면 로그 기록 (Microtask로 렌더링 직후 실행)
    Future.microtask(() => _logScreenView(_selectedIndex));
  }

  // 2. 로그 기록을 위한 헬퍼 함수
  void _logScreenView(int index) {
    String screenName = switch (index) {
      0 => 'Home_Tab',
      1 => 'Feed_Tab',
      2 => 'Friend_Tab',
      3 => 'My_Profile_Tab',
      _ => 'Unknown_Tab',
    };

    FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
      screenClass: 'HomeView', // 현재 클래스명
    );
    print('Analytics: $screenName 기록됨');
  }

  void _onItemTapped(int index) {
    final showModal = ref.read(showModalProvider);
    if (showModal) return;

    // 같은 탭을 또 눌렀을 때는 로그를 남기지 않도록 방어 로직
    if (_selectedIndex == index && index != 0) return;

    setState(() {
      _selectedIndex = index;
      // 홈 탭으로 돌아올 때마다 리프레시
      if (index == 0) {
        _homeContentKey++;
      }
    });

    // 탭 전환 시 로그 기록
    _logScreenView(index);
  }

  @override
  Widget build(BuildContext context) {
    final showModal = ref.watch(showModalProvider);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: IgnorePointer(
            ignoring: showModal,
            child: NavigationBody(
              selectedIndex: _selectedIndex,
              homeContentKey: _selectedIndex == 0
                  ? ValueKey(_homeContentKey)
                  : null,
            ),
          ),
          bottomNavigationBar: IgnorePointer(
            ignoring: showModal,
            child: MainNavigationBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
              onWritePressed: () async {
                if (showModal) return;
                print('Write button tapped');
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FeedAddView()),
                );
                // 게시글 작성 완료 후 게시물 탭으로 이동
                if (result == true && mounted) {
                  // FeedViewModel 새로고침
                  ref
                      .read(feedViewModelProvider.notifier)
                      .fetchFeedsForFriends();
                  setState(() {
                    _selectedIndex = 1;
                  });
                }
              },
              isDisabled: false,
            ),
          ),
        ),

        if (showModal) ...[
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/icon/register_cat_dog.webp",
                            width: 65,
                            height: 64,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 12),
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
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PetRegisterView(),
                                  ),
                                );
                                if (mounted && _selectedIndex == 0) {
                                  setState(() {
                                    _homeContentKey++;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
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
          ),
        ],
      ],
    );
  }
}
