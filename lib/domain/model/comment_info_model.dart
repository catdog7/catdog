import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_info_model.freezed.dart';

@freezed
class CommentInfoModel with _$CommentInfoModel {
  const factory CommentInfoModel({
    required String userId,
    required String nickname,
    required String content,
    DateTime? createdAt,
    required bool isLike,
    required int likeCount,
    String? profileImageUrl,
  }) = _CommentInfoModel;
}
