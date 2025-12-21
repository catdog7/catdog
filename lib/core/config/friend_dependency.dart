import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/friend_repository_impl.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:catdog/domain/use_case/friend_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_dependency.g.dart';

@riverpod
FriendRepository friendRepository(FriendRepositoryRef ref) => 
    FriendRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
FriendUseCase friendUseCase(FriendUseCaseRef ref) => 
    FriendUseCase(ref.read(friendRepositoryProvider));
