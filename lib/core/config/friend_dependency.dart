import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/friend_repository_impl.dart';
import 'package:catdog/domain/repository/friend_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_dependency.g.dart';

@riverpod
FriendRepository friendRepository(FriendRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return FriendRepositoryImpl(client);
}
