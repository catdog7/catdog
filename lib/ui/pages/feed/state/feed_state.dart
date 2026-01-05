import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:catdog/data/dto/feed_dto.dart'; // DTO 경로 확인하세요!

part 'feed_state.freezed.dart';

@freezed
class FeedState with _$FeedState {
  const factory FeedState({
    @Default([]) List<FeedDto> feeds,      // 서버에서 가져온 피드 리스트
    @Default(true) bool isLoading,         // 로딩 상태 (처음엔 true)
    String? errorMessage,                  // 에러 발생 시 메시지
  }) = _FeedState;
}