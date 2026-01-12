import 'package:catdog/data/dto/comment_like_dto.dart';
import 'package:catdog/data/mapper/comment_like_mapper.dart';
import 'package:catdog/data/mapper/comment_mapper.dart';
import 'package:catdog/domain/model/comment_like_model.dart';
import 'package:catdog/domain/repository/comment_like_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CommentLikeRepositoryImpl implements CommentLikeRepository {
  CommentLikeRepositoryImpl(this._client);
  final SupabaseClient _client;

  //해당 코멘트의 좋아요 수 가져오기
  @override
  Future<int> getCommentLikeCount(String commentId) async {
    try {
      final response = await _client
          .from('comment_likes')
          .select()
          .eq('comment_id', commentId)
          .count(CountOption.exact);

      final int likeCount = response.count;
      //print('좋아요 개수: $likeCount');
      return likeCount;
    } catch (e) {
      return 0;
    }
  }

  // 내가 해당 코멘트를 좋아요 했는지
  @override
  Future<bool> checkLiked(String commentId) async {
    try {
      final myId = _client.auth.currentUser?.id;

      if (myId != null) {
        final data = await _client
            .from('comment_likes')
            .select()
            .eq('comment_id', commentId)
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
  Future<void> addLiked(String commentId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      final uuid = Uuid();
      if (myId != null) {
        final commentLikeDto = CommentLikeDto(
          id: uuid.v4(),
          commentId: commentId,
          userId: myId,
          createdAt: DateTime.now(),
        );
        await _client
            .from('comment_likes')
            .upsert(commentLikeDto.toJson(), onConflict: "comment_id, user_id");
      }
    } catch (e) {
      print("코멘트 라이크 추가 실패");
    }
  }

  @override
  Future<void> deleteLiked(String commentId) async {
    try {
      final myId = _client.auth.currentUser?.id;
      if (myId != null) {
        await _client
            .from('comment_likes')
            .delete()
            .eq('comment_id', commentId)
            .eq('user_id', myId);
      }
    } catch (e) {
      print("코멘트 라이크 삭제 실패");
    }
  }
}
