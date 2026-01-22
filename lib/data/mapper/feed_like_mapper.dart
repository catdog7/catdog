import 'package:catdog/data/dto/feed_like_dto.dart';
import 'package:catdog/domain/model/feed_like_model.dart';

class FeedLikeMapper {
  static FeedLikeModel toDomain(FeedLikeDto dto) {
    return FeedLikeModel(
      id: dto.id,
      feedId: dto.feedId,
      userId: dto.userId,
      createdAt: dto.createdAt,
    );
  }

  static FeedLikeDto toDto(FeedLikeModel model) {
    return FeedLikeDto(
      id: model.id,
      feedId: model.feedId,
      userId: model.userId,
      createdAt: model.createdAt,
    );
  }
}
