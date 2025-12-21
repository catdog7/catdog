// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_like_dto.freezed.dart';
part 'feed_like_dto.g.dart';

@freezed
class FeedLikeDto with _$FeedLikeDto {
  const factory FeedLikeDto({
    required String id,
    @JsonKey(name: 'feed_id') required String feedId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FeedLikeDto;

  factory FeedLikeDto.fromJson(Map<String, dynamic> json) => _$FeedLikeDtoFromJson(json);
}
