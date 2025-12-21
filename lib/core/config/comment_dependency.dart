import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/comment_repository_impl.dart';
import 'package:catdog/domain/repository/comment_repository.dart';
import 'package:catdog/domain/use_case/comment_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_dependency.g.dart';

@riverpod
CommentRepository commentRepository(CommentRepositoryRef ref) => 
    CommentRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
CommentUseCase commentUseCase(CommentUseCaseRef ref) => 
    CommentUseCase(ref.read(commentRepositoryProvider));
