import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/data/repository_impl/follow_request_repository_impl.dart';
import 'package:catdog/data/repository_impl/friend_repository_impl.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:catdog/domain/use_case/friend_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_dependency.g.dart';

@riverpod
FriendRepository friendRepository(FriendRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return FriendRepositoryImpl(client);
}

@riverpod
FollowRequestRepository followRequestRepository(
  FollowRequestRepositoryRef ref,
) {
  final client = ref.watch(supabaseClientProvider);
  return FollowRequestRepositoryImpl(client);
}

@riverpod
FriendUseCase friendUseCase(ref) {
  final _userRepo = ref.watch(userRepositoryProvider);
  final _friendRepo = ref.watch(friendRepositoryProvider);
  final _followRepo = ref.watch(followRequestRepositoryProvider);
  return FriendUseCase(_userRepo, _friendRepo, _followRepo);
}

// @riverpod
// FcmRepository fcmRepository(FcmRepositoryRef ref) {
//   final client = ref.watch(supabaseClientProvider);
//   return FcmRepositoryImpl(FirebaseMessaging.instance, client);
// }
