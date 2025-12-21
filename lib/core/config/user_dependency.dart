import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/user_repository_impl.dart';
import 'package:catdog/domain/repository/user_repository.dart';
import 'package:catdog/domain/use_case/user_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_dependency.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => 
    UserRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
UserUseCase userUseCase(UserUseCaseRef ref) => 
    UserUseCase(ref.read(userRepositoryProvider));
