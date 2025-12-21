import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/feed_like_repository_impl.dart';
import 'package:catdog/domain/repository/feed_like_repository.dart';
import 'package:catdog/domain/use_case/feed_like_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_like_dependency.g.dart';

@riverpod
FeedLikeRepository feedLikeRepository(FeedLikeRepositoryRef ref) => 
    FeedLikeRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
FeedLikeUseCase feedLikeUseCase(FeedLikeUseCaseRef ref) => 
    FeedLikeUseCase(ref.read(feedLikeRepositoryProvider));
