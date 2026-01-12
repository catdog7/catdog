import 'package:catdog/domain/model/comment_info_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_state.freezed.dart';

@freezed
abstract class CommentState with _$CommentState {
  const factory CommentState({
    required bool isLoading,
    UserModel? myInfo,
    required String feedId,
    required List<CommentInfoModel> comments,
  }) = _CommentState;
}
