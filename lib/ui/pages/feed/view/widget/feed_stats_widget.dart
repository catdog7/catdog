import 'package:catdog/core/utils/debouncer.dart';
import 'package:catdog/ui/pages/comment/view/comment_view.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_like_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedStatsWidget extends HookConsumerWidget {
  const FeedStatsWidget(this.feedId, {super.key});
  final String feedId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedLikeViewModelProvider(feedId));
    final vm = ref.read(feedLikeViewModelProvider(feedId).notifier);

    final likeUI = useState(false);
    final likeCountUI = useState(0);

    //state 값으로 재설정
    useEffect(() {
      state.whenOrNull(
        data: (data) {
          likeUI.value = data.isLiked;
          likeCountUI.value = data.likeCount;
        },
      );
      return null;
    }, [state]);

    // 좋아요 디바운스
    final debouncer = useMemoized(
      () => Debouncer(
        duration: const Duration(milliseconds: 500),
        callback: () {
          vm.onToggleLike(feedId);
        },
      ),
    );

    useEffect(() => debouncer.dispose, [debouncer]);

    return state.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: false,
      error: (error, _) => Text("에러: $error"),
      loading: () => Center(
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      data: (data) {
        return Row(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    likeUI.value = !likeUI.value;
                    if (likeUI.value) {
                      likeCountUI.value++;
                    } else {
                      likeCountUI.value--;
                    }
                    debouncer.run();
                  },
                  child: Container(
                    height: 35,
                    color: Colors.transparent,
                    child: likeUI.value
                        ? const Icon(
                            Icons.favorite,
                            size: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFCBC0D),
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF010101),
                          ),
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  likeCountUI.value == 0 ? " " : " ${likeCountUI.value}",
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF010101),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () async {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'comment_sheet_open',
                  parameters: {
                    'feed_id': feedId,
                    'initial_comment_count':
                        data.commentCount, // 열었을 때 댓글이 몇 개였나
                  },
                );
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => CommentView(feedId: feedId),
                );
                if (context.mounted) {
                  await vm.countsRefresh(feedId);
                }
              },
              child: Container(
                height: 35,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.bubble_middle_bottom,
                      size: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF010101),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      data.commentCount == 0 ? " " : " ${data.commentCount}",
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF010101),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
