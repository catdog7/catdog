import 'package:amumal/data/dto/comment_dto.dart';
import 'package:amumal/domain/model/comment_model.dart';

class CommentMapper {
  static CommentModel toDomain(CommentDto dto) => CommentModel(
        id: dto.id,
        writerId: dto.writerId,
        feedId: dto.feedId,
        nickname: dto.nickname,
        content: dto.content,
        createdAt: dto.createdAt,
        modifiedAt: dto.modifiedAt,
      );

  static CommentDto toDto(CommentModel model) => CommentDto(
        id: model.id,
        writerId: model.writerId,
        feedId: model.feedId,
        nickname: model.nickname,
        content: model.content,
        createdAt: model.createdAt,
        modifiedAt: model.modifiedAt,
      );
}