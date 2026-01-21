import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/core/service/widget_service.dart';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/data/repository_impl/feed_repository_impl.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/home/view/pet_edit_view.dart';
import 'package:catdog/ui/pages/home/view/pet_register_view.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> with WidgetsBindingObserver {
  bool _hasLoaded = false;
  bool _showEditPopup = false;
  bool _showAllPets = false;
  bool _showWritingTooltip = true;
  UserModel? _user;
  List<PetModel> _pets = [];
  List<FeedDto> _recentFeeds = [];
  final GlobalKey _moreIconKey = GlobalKey();
  static const Color semanticBackgroundWhite = Color(0xFFFFFFFF);
  static const Color semanticBackgroundLight = Color(0xFFF8FAFE);
  static const Color semanticTextBlack = Color(0xFF121416);
  static const Color semanticTextStrong = Color(0xFF000000);
  static const Color semanticTextWeak = Color(0x4D000000);
  static const Color semanticLineLight = Color(0x0D000000);
  static const Color semanticLineNormal = Color(0x26000000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    // Check if ref is valid before using it
    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        if (mounted) {
          ref.read(showModalProvider.notifier).state = false;
        }
        return;
      }
    
      final userUseCase = ref.read(userUseCaseProvider);
      final user = await userUseCase.getUserProfile(userId);
      
      if (!mounted) return; // Async gap check
      
      final pets = await ref.read(petUseCaseProvider).getMyPets(userId);
      final hasPets = await ref.read(petUseCaseProvider).hasPets(userId);
      final feedRepository = ref.read(feedRepositoryProvider);
      final recentFeeds = await feedRepository.getMyRecentFeeds(userId);
      
      // updatedAt 우선, 없으면 createdAt 기준으로 최신순 정렬
      final sortedFeeds = List<FeedDto>.from(recentFeeds);
      sortedFeeds.sort((a, b) {
        final timeA = a.updatedAt ?? a.createdAt;
        final timeB = b.updatedAt ?? b.createdAt;
        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeB.compareTo(timeA); // 내림차순 (최신이 위로)
      });
      
      // Update Android frame widget with latest feed image
      _updateFrameWidget(sortedFeeds);
      
      if (mounted) {
        setState(() {
          _user = user;
          _pets = pets;
          _recentFeeds = sortedFeeds;
        });
        ref.read(showModalProvider.notifier).state = !hasPets;
      }
    } catch (e) {
      debugPrint('_loadData error: $e');
      if (mounted) {
        ref.read(showModalProvider.notifier).state = false;
      }
    }
  }

  void _updateFrameWidget(List<FeedDto> feeds) {
    final latestImageUrl = feeds.isNotEmpty ? feeds.first.imageUrl : null;
    WidgetService.updateLatestImageUrl(latestImageUrl);
  }

  String _formatBirthDate(PetModel pet) {
    if (pet.birthDatePrecision == 'UNKNOWN') {
      return '나이 모름';
    }
    if (pet.birthDate == null) {
      return '';
    }
    return DateFormat('yyyy년 M월 d일', 'ko_KR').format(pet.birthDate!);
  }

  String _getSpeciesLabel(String species) {
    return species == 'DOG' ? '강아지' : '고양이';
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      debugPrint('_formatTimeAgo: dateTime is null');
      return '';
    }
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    // 디버깅 로그
    debugPrint('_formatTimeAgo: now=$now, dateTime=$dateTime, difference.inSeconds=${difference.inSeconds}, difference.inMinutes=${difference.inMinutes}');
    
    // 음수 차이 (미래 시간)인 경우 "방금 전" 반환
    if (difference.isNegative) {
      debugPrint('_formatTimeAgo: negative difference, returning 방금 전');
      return '방금 전';
    }
    
    final totalSeconds = difference.inSeconds;
    
    // 60초 미만 (0~59초) = 방금 전
    if (totalSeconds < 60) {
      debugPrint('_formatTimeAgo: totalSeconds=$totalSeconds < 60, returning 방금 전');
      return '방금 전';
    }
    
    final totalMinutes = difference.inMinutes;
    // 60분 미만 (1~59분) = N분 전
    if (totalMinutes < 60) {
      debugPrint('_formatTimeAgo: totalMinutes=$totalMinutes, returning ${totalMinutes}분 전');
      return '${totalMinutes}분 전';
    }
    
    final totalHours = difference.inHours;
    // 24시간 미만 (1~23시간) = N시간 전
    if (totalHours < 24) {
      debugPrint('_formatTimeAgo: totalHours=$totalHours, returning ${totalHours}시간 전');
      return '${totalHours}시간 전';
    }
    
    final totalDays = difference.inDays;
    // 7일 미만 (1~6일) = N일 전
    if (totalDays < 7) {
      debugPrint('_formatTimeAgo: totalDays=$totalDays, returning ${totalDays}일 전');
      return '${totalDays}일 전';
    }
    
    // 7일 이상 = M월 d일 형식
    final formatted = DateFormat('M월 d일', 'ko_KR').format(dateTime);
    debugPrint('_formatTimeAgo: totalDays=$totalDays >= 7, returning $formatted');
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _user?.nickname ?? '사용자';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: semanticBackgroundLight,
                shape: BoxShape.circle,
                border: Border.all(color: semanticLineLight),
              ),
              child: _user?.profileImageUrl != null && _user!.profileImageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        _user!.profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, size: 16, color: semanticTextBlack),
                      ),
                    )
                  : const Icon(Icons.person, size: 16, color: semanticTextBlack),
            ),
            const SizedBox(width: 8),
            Text(
              nickname,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: semanticTextBlack,
              ),
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.logout,
          //     color: semanticTextBlack,
          //   ),
          //   onPressed: () async {
          //     // Clear frame widget data before logout
          //     await WidgetService.clearWidgetData();
          //     
          //     final client = ref.read(supabaseClientProvider);
          //     await client.auth.signOut();
          //     if (mounted) {
          //       Navigator.of(context).pushAndRemoveUntil(
          //         MaterialPageRoute(
          //           builder: (context) => const LoginView(),
          //         ),
          //         (route) => false,
          //       );
          //     }
          //   },
          // ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_showEditPopup) {
            setState(() => _showEditPopup = false);
          }
        },
        child: Stack(
          children: [
            Positioned(
              top: 123,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: semanticBackgroundLight),
            ),

            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildMyPetsHeader(),
                        _buildPetList(),
                        const SizedBox(height: 16),
                        _buildRecentPostsSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_showWritingTooltip)
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(child: _buildWritingTooltip()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPetsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '내 동물',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: semanticTextStrong,
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: semanticBackgroundWhite,
                surfaceTintColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: semanticTextBlack,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: semanticLineNormal),
                ),
                elevation: 10,
              ),
            ),
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_vert,
                key: _moreIconKey,
                size: 24,
                color: semanticTextBlack,
              ),
              offset: const Offset(0, 40),
              onSelected: (value) async {
                if (value == 'edit') {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PetEditView()),
                  );
                  await _loadData();
                } else if (value == 'add') {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PetRegisterView()),
                  );
                  await _loadData();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  height: 32,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      '삭제',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const PopupMenuDivider(height: 1),
                const PopupMenuItem(
                  value: 'add',
                  height: 32,
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        '수정',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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
    );
  }

  Widget _buildPetList() {
    if (_pets.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayedPets = _showAllPets ? _pets : _pets.take(3).toList();
    final hasMorePets = _pets.length >= 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ...displayedPets.map((pet) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPetCard(pet),
              )),
          if (hasMorePets && !_showAllPets)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: 335,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showAllPets = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: semanticBackgroundWhite,
                    side: const BorderSide(color: semanticLineNormal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '더보기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: semanticTextBlack,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: semanticTextBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPetCard(PetModel pet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: pet.image2dUrl != null && pet.image2dUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      pet.image2dUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(
                            Icons.pets,
                            size: 29,
                            color: semanticTextBlack,
                          ),
                    ),
                  )
                : Icon(
                    Icons.pets,
                    size: 29,
                    color: semanticTextBlack,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: semanticTextBlack,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE6A4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getSpeciesLabel(pet.species),
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: semanticTextBlack,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatBirthDate(pet),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPostsSection() {
    return Column(
      children: [
        Container(height: 6, color: semanticLineLight),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '최근 게시글',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: semanticTextBlack,
              ),
            ),
          ),
        ),
        if (_recentFeeds.isEmpty)
          Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.description_outlined, size: 40, color: semanticTextWeak),
              const SizedBox(height: 12),
              const Text(
                '아직 게시글이 없어요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: semanticTextWeak,
                  fontSize: 15,
                ),
              ),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: _recentFeeds.map((feed) => _buildFeedCard(feed)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFeedCard(FeedDto feed) {
    // updatedAt이 있으면 updatedAt 사용, 없으면 createdAt 사용
    final timeToUse = feed.updatedAt ?? feed.createdAt;
    
    // 디버깅 로그
    debugPrint('_buildFeedCard: feed.id=${feed.id}, createdAt=${feed.createdAt}, updatedAt=${feed.updatedAt}, timeToUse=$timeToUse');
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: semanticBackgroundWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              feed.content ?? '',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: semanticTextBlack,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatTimeAgo(timeToUse),
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: semanticTextWeak,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWritingTooltip() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xE01B1C1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '댕냥이들의 일상을 작성해봐요!',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Color(0xFFF7F7F8),
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showWritingTooltip = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFFF7F7F8),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -6,
          child: CustomPaint(
            size: const Size(12, 6),
            painter: _TrianglePainter(),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xE01B1C1E)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

