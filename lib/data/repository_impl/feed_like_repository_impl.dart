import 'package:catdog/data/dto/feed_like_dto.dart';
import 'package:catdog/domain/repository/feed_like_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FeedLikeRepositoryImpl implements FeedLikeRepository {
  FeedLikeRepositoryImpl(this._client);
  final SupabaseClient _client;
  @override
  Future<void> addLiked(String feedId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      final uuid = Uuid();
      if (myId != null) {
        final feedLikeDto = FeedLikeDto(
          id: uuid.v4(),
          feedId: feedId,
          userId: myId,
          createdAt: DateTime.now(),
        );
        await _client
            .from('feed_likes')
            .upsert(feedLikeDto.toJson(), onConflict: "feed_id, user_id");
      }
    } catch (e) {
      print("피드 라이크 추가 실패");
    }
  }

  @override
  Future<bool> checkLiked(String feedId) async {
    try {
      final myId = _client.auth.currentUser?.id;

      if (myId != null) {
        final data = await _client
            .from('feed_likes')
            .select()
            .eq('feed_id', feedId)
            .eq('user_id', myId)
            .maybeSingle(); // 데이터가 없으면 null 반환

        bool isLiked = data != null;
        //print('내가 좋아요 눌렀나?: $isLiked');
        return isLiked;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteLiked(String feedId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      if (myId != null) {
        await _client
            .from('feed_likes')
            .delete()
            .eq('feed_id', feedId)
            .eq('user_id', myId);
      }
    } catch (e) {
      print("피드 라이크 삭제 실패");
    }
  }

  @override
  Future<int> getFeedLikeCount(String feedId) async {
    try {
      final response = await _client
          .from('feed_likes')
          .select()
          .eq('feed_id', feedId)
          .count(CountOption.exact);

      final int likeCount = response.count;
      //print('좋아요 개수: $likeCount');
      return likeCount;
    } catch (e) {
      return 0;
    }
  }
}
