import 'package:catdog/data/dto/feed_dto.dart';

abstract class FeedRepository {
  Future<List<FeedDto>> getFeeds(); // 피드 목록 가져오기 함수 정의
  Future<List<FeedDto>> getMyRecentFeeds(String userId); // 내 최근 게시글 일주일치 가져오기
  Future<List<FeedDto>> getFeedsForFriends(String userId, List<String> friendIds); // 내 친구와 내 글만 가져오기
  Future<void> deleteFeed(String feedId);
  //수정 메서드
  // ✅ {String? newImagePath} 파라미터를 추가합니다.
Future<void> updateFeed(String feedId, String newContent, {String? newImagePath});
  
}
