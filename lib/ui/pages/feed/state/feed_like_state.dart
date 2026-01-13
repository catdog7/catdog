import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_like_state.freezed.dart';

@freezed
abstract class FeedLikeState with _$FeedLikeState {
  const factory FeedLikeState({
    required bool isLoading,
    required String feedId,
    required int commentCount,
    required int likeCount,
    required bool isLiked,
  }) = _FeedLikeState;
}
