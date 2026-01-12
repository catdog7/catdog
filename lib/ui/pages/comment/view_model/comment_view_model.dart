import 'package:catdog/core/config/comment_dependency.dart';
import 'package:catdog/domain/model/comment_info_model.dart';
import 'package:catdog/domain/model/comment_model.dart';
import 'package:catdog/ui/pages/comment/state/comment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_view_model.g.dart';

@riverpod
class CommentViewModel extends _$CommentViewModel {
  @override
  Future<CommentState> build(String feedId) async {
    final useCase = ref.watch(commentUseCaseProvider);
    final [comments, myInfo] = await Future.wait<dynamic>([
      useCase.getAllComments(feedId),
      useCase.getMyInfo(),
    ]);
    final newList = sortComments(comments);
    return CommentState(
      isLoading: false,
      feedId: feedId,
      myInfo: myInfo,
      comments: newList,
    );
  }

  Future<void> onToggleLike(String commentId) async {
    if (state.isLoading || state.value == null) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    final useCase = ref.read(commentUseCaseProvider);
    late bool isLiked;
    List<CommentInfoModel> newList = state.value!.comments.map((comment) {
      if (comment.id == commentId) {
        isLiked = !comment.isLike;
        return comment.copyWith(
          isLike: !comment.isLike,
          likeCount: comment.isLike
              ? comment.likeCount - 1
              : comment.likeCount + 1,
        );
      }
      return comment;
    }).toList();

    state = AsyncData(
      state.value!.copyWith(isLoading: false, comments: newList),
    );

    await useCase.toggleLike(commentId, isLiked);
  }

  Future<void> addComment(CommentInfoModel newComment) async {
    if (state.isLoading || state.value == null) {
      return;
    }

    state = AsyncData(state.value!.copyWith(isLoading: true));
    final useCase = ref.read(commentUseCaseProvider);
    List<CommentInfoModel> newList = state.value!.comments.toList();
    newList = [newComment, ...newList];

    //newList = sortComments(newList);

    state = AsyncData(
      state.value!.copyWith(isLoading: false, comments: newList),
    );
    final newCommentModel = CommentModel(
      id: newComment.id,
      feedId: state.value!.feedId,
      userId: newComment.userId,
      content: newComment.content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (feedId == "") {
      return;
    }
    await useCase.addcomment(newCommentModel);
  }

  Future<void> deleteComment(String commentId) async {
    if (state.value == null || state.value!.isLoading) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    //로컬에서 지우고
    final oldList = state.value!.comments.toList();
    final indexTodelete = state.value!.comments.indexWhere(
      (comment) => comment.id == commentId,
    );

    if (indexTodelete == -1) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      return;
    }

    final newList = List<CommentInfoModel>.from(state.value!.comments);
    newList.removeAt(indexTodelete);
    state = AsyncData(state.value!.copyWith(comments: newList));

    //db에서 지우기
    final useCase = ref.read(commentUseCaseProvider);
    final result = await useCase.deleteComment(commentId);
    if (!result) {
      print("뷰모델 삭제 메서드, 코멘트 삭제 실패");
      state = AsyncData(
        state.value!.copyWith(isLoading: false, comments: oldList),
      );
    } else {
      state = AsyncData(state.value!.copyWith(isLoading: false));
      print("댓글 삭제 완료");
    }
  }

  List<CommentInfoModel> sortComments(List<CommentInfoModel> comments) {
    final newList = List<CommentInfoModel>.from(comments);

    newList.sort((a, b) {
      int compare = b.likeCount.compareTo(a.likeCount);
      if (compare != 0) return compare;

      final dateB = b.createdAt ?? DateTime.now();
      final dateA = a.createdAt ?? DateTime.now();

      return dateB.compareTo(dateA);
    });

    return newList;
  }
}
