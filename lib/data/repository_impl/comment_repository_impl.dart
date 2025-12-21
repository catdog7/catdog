import 'package:catdog/data/dto/comment_dto.dart';
import 'package:catdog/data/mapper/comment_mapper.dart';
import 'package:catdog/domain/model/comment_model.dart';
import 'package:catdog/domain/repository/comment_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> addComment(CommentModel comment) async {
    final dto = CommentMapper.toDto(comment);
    await client.from('comments').insert(dto.toJson());
  }

  @override
  Future<List<CommentModel>> getCommentsByFeedId(String feedId) async {
    final data = await client.from('comments').select().eq('feed_id', feedId).order('created_at', ascending: true);
    return (data as List).map((e) => CommentMapper.toDomain(CommentDto.fromJson(e))).toList();
  }

  @override
  Future<void> deleteComment(String id) async {
    await client.from('comments').delete().eq('id', id);
  }
}
