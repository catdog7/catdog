import 'package:amumal/core/config/comment_dependency.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/ui/pages/comments/state/comment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_view_model.g.dart';

typedef CommentViewModelParams = ({String feedId, UserModel user});

@riverpod
class CommentViewModel extends _$CommentViewModel {
  String? _feedId;
  UserModel? _user;

  @override
  Future<CommentState> build({
    required String feedId,
    required UserModel user,
  }) async {
    _feedId = feedId;
    _user = user;

    final useCase = ref.read(commentUseCaseProvider);
    final comments = await useCase.getCommentsByFeedId(feedId: feedId);

    return CommentState(
      comments: comments,
      isLoading: false,
    );
  }

  /// 댓글 목록 새로고침
  Future<void> refresh() async {
    if (state.value == null || state.value!.isLoading || _feedId == null) {
      return;
    }

    state = AsyncData(state.value!.copyWith(isLoading: true));
    try {
      final useCase = ref.read(commentUseCaseProvider);
      final comments = await useCase.getCommentsByFeedId(feedId: _feedId!);

      state = AsyncData(
        state.value!.copyWith(
          comments: comments,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
    }
  }

  /// 댓글 등록
  Future<void> createComment({required String content}) async {
    if (state.value == null || 
        state.value!.isCreating || 
        content.trim().isEmpty ||
        _feedId == null ||
        _user == null) {
      return;
    }

    state = AsyncData(state.value!.copyWith(isCreating: true));
    try {
      final useCase = ref.read(commentUseCaseProvider);
      final newComment = await useCase.createComment(
        writerId: _user!.id ?? '',
        feedId: _feedId!,
        nickname: _user!.nickname,
        content: content.trim(),
      );

      final updatedComments = [newComment, ...state.value!.comments];
      state = AsyncData(
        state.value!.copyWith(
          comments: updatedComments,
          isCreating: false,
        ),
      );
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isCreating: false));
      rethrow;
    }
  }

  /// 댓글 삭제
  Future<void> deleteComment(String commentId) async {
    if (state.value == null || commentId.isEmpty) return;

    // 1. 로컬 상태에서 먼저 제거 (낙관적 업데이트)
    final updatedComments = state.value!.comments
        .where((comment) => comment.id != commentId)
        .toList();
    
    // 2. 임시 상태 업데이트
    state = AsyncData(state.value!.copyWith(comments: updatedComments));

    try {
      // 3. UseCase 호출하여 실제 삭제
      final useCase = ref.read(commentUseCaseProvider);
      final success = await useCase.deleteComment(commentId: commentId);
      
      // 4. 실패 시 원래 상태로 복원
      if (!success) {
        // 원래 상태로 복원하거나 refresh() 호출
        await refresh();
        throw Exception('댓글 삭제에 실패했습니다.');
      }
      // 성공 시 이미 상태가 업데이트되어 있으므로 추가 작업 없음
    } catch (e) {
      // 5. 에러 발생 시 원래 상태로 복원
      await refresh();
      rethrow;
    }
  }
}

