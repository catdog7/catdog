import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/ui/pages/feed/view/feed_edit_view.dart';
import 'package:catdog/ui/pages/feed/view/widget/feed_empty_state.dart';
import 'package:catdog/ui/pages/feed/state/feed_state.dart';
import 'package:catdog/ui/pages/feed/view/widget/feed_stats_widget.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/home/view/friend_home_view.dart';
import 'package:catdog/ui/widgets/delete_dialog.dart';
import 'package:catdog/ui/widgets/more_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedView extends ConsumerStatefulWidget {
  const FeedView({super.key});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // FeedView가 재생성될 때 스크롤을 최상단으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedViewModelProvider);

    // 게시글 목록이 로드되면 스크롤을 최상단으로 이동
    ref.listen<FeedState>(feedViewModelProvider, (previous, next) {
      if (previous != null &&
          previous.isLoading &&
          !next.isLoading &&
          next.feeds.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFE),
        elevation: 0,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          '게시글',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
      ),
      body: SafeArea(
        child: feedState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : feedState.errorMessage != null
            ? Center(child: Text(feedState.errorMessage!))
            : feedState.feeds.isEmpty
            ? const FeedEmptyState()
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: feedState.feeds.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final feed = feedState.feeds[index];
                    return myFeedCard(context, ref, feed);
                  },
                ),
              ),
      ),
    );
  }
}

Widget myFeedCard(BuildContext context, WidgetRef ref, FeedDto feed) {
  final client = ref.read(supabaseClientProvider);
  final currentUserId = client.auth.currentUser?.id;
  final isMyFeed = currentUserId != null && feed.userId == currentUserId;

  return FutureBuilder<UserModel?>(
    future: ref.read(userUseCaseProvider).getUserProfile(feed.userId),
    builder: (context, snapshot) {
      final user = snapshot.data;
      final nickname = user?.nickname ?? '';
      final profileImageUrl = user?.profileImageUrl;

      return Container(
        width: 335,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x0D000000), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isMyFeed) {
                      // 내 게시글이면 홈으로 이동 (홈 탭 활성화)
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeView(initialIndex: 0),
                        ),
                        (route) => false,
                      );
                    } else {
                      // 다른 사람 게시글이면 친구 홈으로 이동
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              FriendHomeView(friendUserId: feed.userId),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD9D9D9),
                    ),
                    child: profileImageUrl != null && profileImageUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 18),
                            ),
                          )
                        : const Icon(Icons.person, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isMyFeed) {
                        // 내 게시글이면 홈으로 이동 (홈 탭 활성화)
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeView(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      } else {
                        // 다른 사람 게시글이면 친구 홈으로 이동
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FriendHomeView(friendUserId: feed.userId),
                          ),
                        );
                      }
                    },
                    child: Text(
                      nickname.isNotEmpty ? nickname : '사용자',
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
                if (isMyFeed)
                  MoreWidget(
                    menus: [
                      MenuAction(
                        title: '수정',
                        onTap: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedEditView(feed: feed),
                            ),
                          );
                        },
                      ),
                      MenuAction(
                        title: '삭제',
                        onTap: (_) async {
                          // 삭제 확인 팝업
                          final result = await DeleteDialog.show(
                            context: context,
                            title: '게시글을 삭제하시겠습니까?',
                          );
                          if (result == true) {
                            print("삭제 팝업 결과 true");
                            ref
                                .read(feedViewModelProvider.notifier)
                                .deleteFeed(feed.id);
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: 295,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      feed.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFD9D9D9),
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FeedStatsWidget(feed.id),
            const SizedBox(height: 12),
            Text(
              feed.content ?? '',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF121416),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              feed.createdAt != null
                  ? DateFormat('yyyy년 M월 d일', 'ko_KR').format(feed.createdAt!)
                  : '',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0x4D000000),
              ),
            ),
          ],
        ),
      );
    },
  );
}
