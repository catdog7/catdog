import 'package:amumal/domain/model/feed_model.dart';
import 'dart:io';

/// Feed 저장/조회를 담당하는 Repository 인터페이스
/// Repository는 Firestore/Firebase Storage와의 입출력만 담당
abstract class FeedRepository {
  /// 이미지 업로드 (Firebase Storage)
  Future<String> uploadImage({
    required File imageFile,
    required String writerId,
  });

  /// 피드 저장 (Firestore)
  Future<FeedModel> createFeed({required FeedModel feed});
  Future<FeedModel> modifyFeed({required FeedModel feed});
}

