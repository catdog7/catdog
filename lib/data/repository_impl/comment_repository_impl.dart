import 'package:amumal/data/dto/comment_dto.dart';
import 'package:amumal/data/mapper/comment_mapper.dart';
import 'package:amumal/domain/model/comment_model.dart';
import 'package:amumal/domain/repository/comment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepositoryImpl implements CommentRepository {
  final FirebaseFirestore firebase;
  CommentRepositoryImpl({required this.firebase});

  @override
  Future<CommentModel> createComment({required CommentModel comment}) async {
    final dto = CommentMapper.toDto(comment);

    final docRef = await firebase.collection('comments').add(dto.toJson());
    final doc = await docRef.get();
    return CommentMapper.toDomain(CommentDto.fromDoc(doc));
  }

  @override
  Future<List<CommentModel>> getCommentsByFeedId({
    required String feedId,
  }) async {
    final querySnapshot = await firebase
        .collection('comments')
        .where('feed_id', isEqualTo: feedId)
        .orderBy('created_at', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => CommentMapper.toDomain(CommentDto.fromDoc(doc)))
        .toList();
  }
  
  @override
  Future<bool> deleteComment({required String commentId}) async {
    try {
      final docRef = firebase.collection('comments').doc(commentId);
      await docRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
