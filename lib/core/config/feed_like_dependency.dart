import 'package:catdog/core/config/comment_dependency.dart';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/feed_like_repository_impl.dart';
import 'package:catdog/domain/repository/feed_like_repository.dart';
import 'package:catdog/domain/use_case/feed_like_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_like_dependency.g.dart';

@riverpod
FeedLikeRepository feedLikeRepository(FeedLikeRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return FeedLikeRepositoryImpl(client);
}

@riverpod
FeedLikeUseCase feedLikeUseCase(ref) {
  final _commentRepo = ref.watch(commentRepositoryProvider);
  final _feedLikeRepo = ref.watch(feedLikeRepositoryProvider);
  return FeedLikeUseCase(_commentRepo, _feedLikeRepo);
}
