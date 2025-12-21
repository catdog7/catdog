import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_model.freezed.dart';

@freezed
class FeedModel with _$FeedModel {
  const factory FeedModel({
    required String id,
    required String userId,
    required String imageUrl,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FeedModel;
}
