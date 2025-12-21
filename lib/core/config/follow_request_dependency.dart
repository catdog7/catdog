import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/follow_request_repository_impl.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:catdog/domain/use_case/follow_request_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_request_dependency.g.dart';

@riverpod
FollowRequestRepository followRequestRepository(FollowRequestRepositoryRef ref) => 
    FollowRequestRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
FollowRequestUseCase followRequestUseCase(FollowRequestUseCaseRef ref) => 
    FollowRequestUseCase(ref.read(followRequestRepositoryProvider));
