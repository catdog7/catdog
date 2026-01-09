// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'comment_view_model.g.dart';

// @riverpod
// class CommentViewModel extends _$CommentViewModel {
//   @override
//   Future<FriendState> build() async {
//     final link = ref.keepAlive();
//     Timer(const Duration(minutes: 5), () {
//       link.close();
//     });
//     final useCase = ref.watch(friendUseCaseProvider);
//     final friends = await useCase.getMyFriends();
//     return FriendState(isLoading: false, friends: friends);
//   }
// }
