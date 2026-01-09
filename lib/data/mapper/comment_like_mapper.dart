import 'package:catdog/data/dto/comment_like_dto.dart';
import 'package:catdog/domain/model/comment_like_model.dart';

class CommentLikeMapper {
  static CommentLikeModel toDomain(CommentLikeDto dto) {
    return CommentLikeModel(
      id: dto.id,
      commentId: dto.commentId,
      userId: dto.userId,
      createdAt: dto.createdAt,
    );
  }

  static CommentLikeDto toDto(CommentLikeModel model) {
    return CommentLikeDto(
      id: model.id,
      commentId: model.commentId,
      userId: model.userId,
      createdAt: model.createdAt,
    );
  }
}
