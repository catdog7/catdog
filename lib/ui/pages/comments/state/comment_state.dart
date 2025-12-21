import 'package:amumal/domain/model/comment_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_state.freezed.dart';

@freezed
class CommentState with _$CommentState {
  const factory CommentState({
    required List<CommentModel> comments,
    required bool isLoading,
    @Default(false) bool isCreating,
  }) = _CommentState;
}

