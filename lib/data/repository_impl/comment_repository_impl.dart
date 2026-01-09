import 'package:catdog/data/dto/comment_dto.dart';
import 'package:catdog/data/mapper/comment_mapper.dart';
import 'package:catdog/domain/model/comment_model.dart';
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
  Future<void> deleteComment(String commentId) async {
    try {
      await _client.from('comments').delete().eq('id', commentId);
    } catch (e) {
      print("comment 삭제 실패");
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
}
