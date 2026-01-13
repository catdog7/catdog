import 'package:catdog/data/dto/feed_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mypage_state.freezed.dart';

@freezed
class MypageState with _$MypageState {
  const factory MypageState({
    @Default(false) bool isLoading,
    String? nickname,
    String? profileImageUrl,
    String? inviteCode,
    @Default([]) List<FeedDto> myFeeds, // 내가 쓴 글 목록
    String? errorMessage,
  }) = _MypageState;
}