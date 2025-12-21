// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_dto.freezed.dart';
part 'feed_dto.g.dart';

@freezed
class FeedDto with _$FeedDto {
  const factory FeedDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'image_url') required String imageUrl,
    String? content,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FeedDto;

  factory FeedDto.fromJson(Map<String, dynamic> json) => _$FeedDtoFromJson(json);
}
