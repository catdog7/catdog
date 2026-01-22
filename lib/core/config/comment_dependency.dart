import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/data/repository_impl/comment_like_repository_impl.dart';
import 'package:catdog/data/repository_impl/comment_repository_impl.dart';
import 'package:catdog/domain/repository/comment_like_repository.dart';
import 'package:catdog/domain/repository/comment_repository.dart';
import 'package:catdog/domain/use_case/comment_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_dependency.g.dart';

@riverpod
CommentRepository commentRepository(CommentRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return CommentRepositoryImpl(client);
}

@riverpod
CommentLikeRepository commentLikeRepository(CommentLikeRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return CommentLikeRepositoryImpl(client);
}

@riverpod
CommentUseCase commentUseCase(ref) {
  final _commentRepo = ref.watch(commentRepositoryProvider);
  final _commentLikeRepo = ref.watch(commentLikeRepositoryProvider);
  final _userRepo = ref.watch(userRepositoryProvider);
  return CommentUseCase(_commentRepo, _commentLikeRepo, _userRepo);
}
