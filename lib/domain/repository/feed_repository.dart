import 'package:catdog/data/dto/feed_dto.dart';

abstract class FeedRepository {
  Future<List<FeedDto>> getFeeds(); // 피드 목록 가져오기 함수 정의
}