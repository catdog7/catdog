import 'package:catdog/data/dto/comment_dto.dart';
import 'package:catdog/domain/model/comment_model.dart';

class CommentMapper {
  static CommentModel toDomain(CommentDto dto) {
    return CommentModel(
      id: dto.id,
      feedId: dto.feedId,
      userId: dto.userId,
      content: dto.content,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static CommentDto toDto(CommentModel model) {
    return CommentDto(
      id: model.id,
      feedId: model.feedId,
      userId: model.userId,
      content: model.content,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
