import 'package:amumal/data/dto/feed_dto.dart';
import 'package:amumal/data/mapper/feed_mapper.dart';
import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/domain/repository/home_feed_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeFeedRepositoryImpl implements HomeFeedRepository {
  final FirebaseFirestore firebase;
  HomeFeedRepositoryImpl({required this.firebase});
  @override
  Future<bool> deleteFeed({required String feedId}) async {
    try {
      final docRef = firebase.collection('feeds').doc(feedId);
      await docRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<(List<FeedModel>, DocumentSnapshot<Object?>?)> fetchInitial({
    required int limit,
  }) async {
    try {
      final querySnapshot = await firebase
          .collection('feeds')
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();

      List<FeedModel> feedList = querySnapshot.docs
          .map((e) => FeedMapper.toDomain(FeedDto.fromDoc(e)))
          .toList();

      return (feedList, querySnapshot.docs.last);
    } catch (e) {
      return (<FeedModel>[], null);
    }
  }

  @override
  Future<(List<FeedModel>, DocumentSnapshot<Object?>?)> fetchMore({
    required int limit,
    required DocumentSnapshot<Object?> lastDocument,
  }) async {
    try {
      final querySnapshot = await firebase
          .collection('feeds')
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(lastDocument)
          .get();

      List<FeedModel> feedList = querySnapshot.docs
          .map((e) => FeedMapper.toDomain(FeedDto.fromDoc(e)))
          .toList();

      return (feedList, querySnapshot.docs.last);
    } catch (e) {
      return (<FeedModel>[], null);
    }
  }

  @override
  Future<FeedModel?> getFeed({required String id}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firebase
          .collection('feeds')
          .doc(id)
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return FeedMapper.toDomain(FeedDto.fromDoc(docSnapshot));
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
