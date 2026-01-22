import 'package:catdog/ui/pages/feed/view/feed_add_view.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedEmptyState extends ConsumerWidget {
  const FeedEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 48,
            color: Color(0xFF999999),
          ),
          const SizedBox(height: 16),
          const Text(
            '아직 게시물이 없어요.',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '지금 댕냥이의 일상을 공유해봐요!',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0x4D000000),
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FeedAddView()),
              );
              if (result == true && context.mounted) {
                ref.read(feedViewModelProvider.notifier).fetchFeedsForFriends();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDCA40),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '작성하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF121416),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF121416),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

