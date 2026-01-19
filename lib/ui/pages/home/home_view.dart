import 'package:catdog/ui/pages/feed/view/feed_add_view.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:catdog/ui/pages/home/widgets/navigation_body.dart';
import 'package:catdog/ui/pages/home/view/pet_register_view.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:catdog/ui/pages/login/nickname_view.dart';
import 'package:catdog/ui/widgets/main_navigation_bar.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


final showModalProvider = StateProvider<bool>((ref) => false);

class HomeView extends ConsumerStatefulWidget {
  final int initialIndex;
  final String? initialDeepLink;
  
  const HomeView({super.key, this.initialIndex = 1, this.initialDeepLink});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late int _selectedIndex;
  int _homeContentKey = 0;
  static const _channel = MethodChannel('com.team.catdog/widget');
  bool _isHandlingDeepLink = false;
  DateTime? _lastHandledTime;
  bool _hasPendingNavigation = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    // 앱 진입 시 첫 화면 로그 기록 (Microtask로 렌더링 직후 실행)
    Future.microtask(() => _logScreenView(_selectedIndex));
    
    // 리스너를 최대한 빨리 등록하여 신호를 놓치지 않도록 함
    _setupWidgetLink();

    // SplashView에서 전달된 딥링크 처리 (Cold Start)
    if (widget.initialDeepLink != null) {
      debugPrint('HomeView: Processing initialDeepLink from SplashView: ${widget.initialDeepLink}');
      _hasPendingNavigation = true;
      _lastHandledTime = DateTime.now();
    }

    // 위젯 빌드가 끝난 후 실행되도록 보장 (다이얼로그 표시 및 지연된 네비게이션 처리)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfRegistrationRequired();
      _processPendingNavigation();
    });
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

  void _checkIfRegistrationRequired() {
    // 1. 현재 HomeView가 최상단 화면이 아니면(이미 다이얼로그 등이 떠 있으면) 실행하지 않음
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

    // 2. 댕냥댕냥 환영 모달이 필요한 경우 다이얼로그로 표시
    if (ref.read(showModalProvider)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => RegisterPetDialog(
          onRegister: () {
            if (mounted && _selectedIndex == 0) {
              setState(() {
                _homeContentKey++;
              });
            }
          },
        ),
      );
    }
  }

  void _setupWidgetLink() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final String uri = call.arguments;
        _handleDeepLink(uri);
      }
    });

    _channel.invokeMethod<String>('getInitialUri').then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(String uri) {
    // 1000ms 이내의 중복 신호는 무시 (디바운스)
    final now = DateTime.now();
    if (_lastHandledTime != null && 
        now.difference(_lastHandledTime!) < const Duration(milliseconds: 1000)) {
      print('Deep link debounced: $uri');
      return;
    }

    if (_isHandlingDeepLink) {
      print('Deep link handling already in progress, ignoring: $uri');
      return;
    }

    // 전용 스킴(catdog-widget)만 처리하여 다른 핸들러와의 충돌 방지
    if (uri == 'catdog-widget://post') {
      _lastHandledTime = now;
      print('Deep link detected, setting pending flag');
      _hasPendingNavigation = true;
      
      // HomeView가 완전히 로드된 후 처리하도록 다음 프레임으로 연기
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processPendingNavigation();
      });
    }
  }

  void _processPendingNavigation() {
    if (_hasPendingNavigation && mounted) {
      _hasPendingNavigation = false;
      print('Processing pending navigation to FeedAddView');
      _openFeedAddView();
    }
  }

  void _openFeedAddView() async {
    if (!mounted || _isHandlingDeepLink) return;
    
    setState(() {
      _isHandlingDeepLink = true;
    });

    try {
      final client = ref.read(supabaseClientProvider);
      final userUseCase = ref.read(userUseCaseProvider);
      final petUseCase = ref.read(petUseCaseProvider);

      // 1. 로그인 체크
      final session = client.auth.currentSession;
      if (session == null) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        }
        return;
      }

      // 2. 닉네임 설정 체크
      final hasNickname = await userUseCase.hasNickname(session.user.id);
      if (!hasNickname) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NicknameView()),
          );
        }
        return;
      }

      // 3. 반려동물 등록 체크 (0마리면 홈 화면에서 등록 다이얼로그 노출)
      final hasPets = await petUseCase.hasPets(session.user.id);
      if (!hasPets) {
        if (mounted) {
          // 이미 띄워져 있을 수 있으므로 체크 후 표시
          _checkIfRegistrationRequired();
        }
        return;
      }

      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FeedAddView()),
      );
      
      if (result == true && mounted) {
        ref.read(feedViewModelProvider.notifier).fetchFeedsForFriends();
        // 위젯에서 온 경우 게시글 탭으로 이동하지 않음
        // setState(() {
        //   _selectedIndex = 1;
        // });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isHandlingDeepLink = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: NavigationBody(
        selectedIndex: _selectedIndex,
        homeContentKey: _selectedIndex == 0 ? ValueKey(_homeContentKey) : null,
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onWritePressed: _openFeedAddView,
        isDisabled: false,
      ),
    );
  }
}

/// 별도의 다이얼로그 위젯으로 분리 (가독성 향상)
class RegisterPetDialog extends StatelessWidget {
  final VoidCallback onRegister;

  const RegisterPetDialog({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
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
                padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
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
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PetRegisterView(),
                            ),
                          );
                          onRegister();
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
    );
  }
}

