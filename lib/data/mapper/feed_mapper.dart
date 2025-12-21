import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/domain/model/feed_model.dart';

class FeedMapper {
  static FeedModel toDomain(FeedDto dto) {
    return FeedModel(
      id: dto.id,
      userId: dto.userId,
      imageUrl: dto.imageUrl,
      content: dto.content,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static FeedDto toDto(FeedModel model) {
    return FeedDto(
      id: model.id,
      userId: model.userId,
      imageUrl: model.imageUrl,
      content: model.content,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
