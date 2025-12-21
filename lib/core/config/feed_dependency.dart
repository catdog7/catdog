import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/feed_repository_impl.dart';
import 'package:catdog/domain/repository/feed_repository.dart';
import 'package:catdog/domain/use_case/feed_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_dependency.g.dart';

@riverpod
FeedRepository feedRepository(FeedRepositoryRef ref) => 
    FeedRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
FeedUseCase feedUseCase(FeedUseCaseRef ref) => 
    FeedUseCase(ref.read(feedRepositoryProvider));
