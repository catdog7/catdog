import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_like_model.freezed.dart';

@freezed
class FeedLikeModel with _$FeedLikeModel {
  const factory FeedLikeModel({
    required String id,
    required String feedId,
    required String userId,
    DateTime? createdAt,
  }) = _FeedLikeModel;
}
