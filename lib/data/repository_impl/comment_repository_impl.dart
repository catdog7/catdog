import 'package:catdog/data/dto/comment_dto.dart';
import 'package:catdog/data/dto/user_dto.dart';
import 'package:catdog/data/mapper/comment_mapper.dart';
import 'package:catdog/data/mapper/user_mapper.dart';
import 'package:catdog/domain/model/comment_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/comment_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<void> addComment(CommentModel comment) async {
    try {
      await _client
          .from('comments')
          .insert(CommentMapper.toDto(comment).toJson());
    } catch (e) {
      print("comment 추가 실패");
    }
  }

  @override
  Future<bool> deleteComment(String commentId) async {
    try {
      await _client.from('comments').delete().eq('id', commentId);
      return true;
    } catch (e) {
      print("comment 삭제 실패");
      return false;
    }
  }

  @override
  Future<List<CommentModel>> getComments(String feedId) async {
    try {
      final response = await _client
          .from('comments')
          .select()
          .eq('feed_id', feedId)
          .order('created_at', ascending: false);
      return response
          .map((json) => CommentMapper.toDomain(CommentDto.fromJson(json)))
          .toList();
    } catch (e) {
      print("comments 가져오기 실패");
      return [];
    }
  }

  @override
  Future<UserModel?> getMyInfo() async {
    try {
      final myId = _client.auth.currentUser?.id;
      if (myId == null) {
        return null;
      }
      final response = await _client
          .from('users')
          .select()
          .eq('id', myId)
          .maybeSingle();

      if (response == null) return null;

      // UserDto의 required 필드들이 null인 경우를 처리
      final responseCopy = Map<String, dynamic>.from(response);

      // id가 null인 경우 처리 (필수 필드)
      if (responseCopy['id'] == null) {
        responseCopy['id'] = myId; // 파라미터로 받은 id 사용
      }

      // nickname이 null이거나 빈 문자열인 경우 빈 문자열로 설정
      if (responseCopy['nickname'] == null ||
          (responseCopy['nickname'] is String &&
              (responseCopy['nickname'] as String).trim().isEmpty)) {
        responseCopy['nickname'] = '';
      }

      // invite_code가 null인 경우 빈 문자열로 설정 (스키마상 nullable이지만 DTO는 required)
      if (responseCopy['invite_code'] == null) {
        responseCopy['invite_code'] = '';
      }

      return UserMapper.toModel(UserDto.fromJson(responseCopy));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> getCommentCount(String feedId) async {
    try {
      final response = await _client
          .from('comments')
          .select('id')
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
