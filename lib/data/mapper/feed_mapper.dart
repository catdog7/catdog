import 'package:amumal/data/dto/feed_dto.dart';
import 'package:amumal/domain/model/feed_model.dart';

class FeedMapper {
  static FeedModel toDomain(FeedDto dto) => FeedModel(
        id: dto.id,
        writerId: dto.writerId,
        nickname: dto.nickname,
        tag: dto.tag,
        content: dto.content,
        imageUrl: dto.imageUrl,
        createdAt: dto.createdAt,
        modifiedAt: dto.modifiedAt,
      );

  static FeedDto toDto(FeedModel model) => FeedDto(
        id: model.id,
        writerId: model.writerId,
        nickname: model.nickname,
        tag: model.tag,
        content: model.content,
        imageUrl: model.imageUrl,
        createdAt: model.createdAt,
        modifiedAt: model.modifiedAt,
      );
}