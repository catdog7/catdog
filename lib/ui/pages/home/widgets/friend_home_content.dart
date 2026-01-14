import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/data/repository_impl/feed_repository_impl.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendHomeContent extends ConsumerStatefulWidget {
  final String friendUserId;

  const FriendHomeContent({super.key, required this.friendUserId});

  @override
  ConsumerState<FriendHomeContent> createState() => _FriendHomeContentState();
}

class _FriendHomeContentState extends ConsumerState<FriendHomeContent>
    with WidgetsBindingObserver {
  bool _hasLoaded = false;
  bool _showAllPets = false;
  UserModel? _user;
  List<PetModel> _pets = [];
  List<FeedDto> _recentFeeds = [];
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
    try {
      final userUseCase = ref.read(userUseCaseProvider);
      final user = await userUseCase.getUserProfile(widget.friendUserId);
      final pets = await ref
          .read(petUseCaseProvider)
          .getMyPets(widget.friendUserId);
      final feedRepository = ref.read(feedRepositoryProvider);
      final recentFeeds = await feedRepository.getMyRecentFeeds(
        widget.friendUserId,
      );

      final sortedFeeds = List<FeedDto>.from(recentFeeds);
      sortedFeeds.sort((a, b) {
        final timeA = a.updatedAt ?? a.createdAt;
        final timeB = b.updatedAt ?? b.createdAt;
        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeB.compareTo(timeA);
      });

      if (mounted) {
        setState(() {
          _user = user;
          _pets = pets;
          _recentFeeds = sortedFeeds;
        });

        // 데이터 로드 완료 후 로그 기록
        FirebaseAnalytics.instance.logScreenView(
          screenName: 'Friend_Home_View',
          screenClass: 'FriendHomeView',
        );

        // 상세 이벤트 로그 (방문한 친구의 정보 포함)
        FirebaseAnalytics.instance.logEvent(
          name: 'visit_friend_home',
          parameters: {
            'friend_id': widget.friendUserId,
            'pet_count': pets.length,
            'post_count': sortedFeeds.length,
          },
        );
      }
    } catch (e) {
      debugPrint('_loadData error: $e');
    }
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
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) return '방금 전';

    final totalSeconds = difference.inSeconds;
    if (totalSeconds < 60) return '방금 전';

    final totalMinutes = difference.inMinutes;
    if (totalMinutes < 60) return '${totalMinutes}분 전';

    final totalHours = difference.inHours;
    if (totalHours < 24) return '${totalHours}시간 전';

    final totalDays = difference.inDays;
    if (totalDays < 7) return '${totalDays}일 전';

    return DateFormat('M월 d일', 'ko_KR').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _user?.nickname ?? '사용자';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: semanticTextBlack,
          ),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              child:
                  _user?.profileImageUrl != null &&
                      _user!.profileImageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        _user!.profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: semanticTextBlack,
                            ),
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 16,
                      color: semanticTextBlack,
                    ),
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
      ),
      body: Stack(
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
                      _buildPetsHeader(),
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
        ],
      ),
    );
  }

  Widget _buildPetsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '동물',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: semanticTextStrong,
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
          ...displayedPets.map(
            (pet) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPetCard(pet),
            ),
          ),
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
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 57,
            height: 57,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: pet.image2dUrl != null && pet.image2dUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      pet.image2dUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.pets,
                        size: 29,
                        color: semanticTextBlack,
                      ),
                    ),
                  )
                : const Icon(Icons.pets, size: 29, color: semanticTextBlack),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
              const Icon(
                Icons.description_outlined,
                size: 40,
                color: semanticTextWeak,
              ),
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
              children: _recentFeeds
                  .map((feed) => _buildFeedCard(feed))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFeedCard(FeedDto feed) {
    final timeToUse = feed.updatedAt ?? feed.createdAt;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: semanticBackgroundWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
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
}
