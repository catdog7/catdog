import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_model.freezed.dart';

@freezed
class FeedModel with _$FeedModel {
  const FeedModel._();

  const factory FeedModel({
    String? id, // Firestore docId → nullable
    required String writerId,
    required String nickname,
    required List<String> tag,
    required String content,
    required String imageUrl,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) = _FeedModel;

  /// 생성자에서 도메인 규칙 검증
  factory FeedModel.create({
    String? id,
    required String writerId,
    required String nickname,
    required List<String> tag,
    required String content,
    required String imageUrl,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) {
    // 도메인 규칙 1: content는 비어있을 수 없음
    if (content.trim().isEmpty) {
      throw ArgumentError('피드 내용은 비어있을 수 없습니다.', 'content');
    }

    // 도메인 규칙 2: content는 200자 이하여야 함
    if (content.length > 200) {
      throw ArgumentError(
        '피드 내용은 200자 이하여야 합니다. (현재: ${content.length}자)',
        'content',
      );
    }

    // 도메인 규칙 3: tag 리스트의 각 요소는 비어있을 수 없음
    if (tag.any((t) => t.trim().isEmpty)) {
      throw ArgumentError('태그는 비어있을 수 없습니다.', 'tag');
    }

    return FeedModel(
      id: id,
      writerId: writerId,
      nickname: nickname,
      tag: tag,
      content: content.trim(),
      imageUrl: imageUrl,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
    );
  }
}
