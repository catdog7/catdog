import 'package:catdog/core/config/feed_like_dependency.dart';
import 'package:catdog/ui/pages/feed/state/feed_like_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_like_view_model.g.dart';

@riverpod
class FeedLikeViewModel extends _$FeedLikeViewModel {
  @override
  Future<FeedLikeState> build(String feedId) async {
    final useCase = ref.watch(feedLikeUseCaseProvider);
    final stats = await useCase.getFeedStats(feedId);
    return FeedLikeState(
      isLoading: false,
      feedId: feedId,
      commentCount: stats.commentCount,
      likeCount: stats.likeCount,
      isLiked: stats.isLiked,
    );
  }

  Future<void> onToggleLike(String feedId) async {
    if (state.isLoading ||
        state.value == null ||
        state.value!.feedId != feedId) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    final useCase = ref.read(feedLikeUseCaseProvider);
    final isLike = !state.value!.isLiked; // 업데이트된 좋아요
    final likeCount = state.value!.likeCount;
    // 로컬 좋아요 토글
    state = AsyncData(
      state.value!.copyWith(
        isLiked: isLike,
        likeCount: isLike ? likeCount + 1 : likeCount - 1,
      ),
    );

    await useCase.toggleLike(feedId, isLike);

    state = AsyncData(state.value!.copyWith(isLoading: false));
  }

  Future<void> countsRefresh(String feedId) async {
    if (state.isLoading ||
        state.value == null ||
        state.value!.feedId != feedId) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    final useCase = ref.read(feedLikeUseCaseProvider);
    final stats = await useCase.getFeedStats(feedId);

    state = AsyncData(
      state.value!.copyWith(
        isLoading: false,
        commentCount: stats.commentCount,
        likeCount: stats.likeCount,
        isLiked: stats.isLiked,
      ),
    );
  }
}
