import 'package:catdog/data/dto/feed_dto.dart';

abstract class FeedRepository {
  Future<List<FeedDto>> getFeeds(); // 피드 목록 가져오기 함수 정의
  Future<void> deleteFeed(String feedId);
  //수정 메서드
  // ✅ {String? newImagePath} 파라미터를 추가합니다.
Future<void> updateFeed(String feedId, String newContent, {String? newImagePath});
  
}
