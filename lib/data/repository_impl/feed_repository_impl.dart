import 'dart:io';

import 'package:amumal/data/dto/feed_dto.dart';
import 'package:amumal/data/mapper/feed_mapper.dart';
import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/domain/repository/feed_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// FeedRepository 인터페이스 구현
/// Repository는 Firestore/Firebase Storage와의 입출력만 담당
class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<String> uploadImage({
    required File imageFile,
    required String writerId,
  }) async {
    // 파일 이름은 고유하게 생성 (현재 시간 ms + .jpg)
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    // 저장 경로: feeds/[작성자 ID]/[파일명]
    final storageRef = _storage.ref().child('feeds/$writerId/$fileName');

    // 파일 업로드
    await storageRef.putFile(imageFile);

    // 업로드된 이미지의 다운로드 URL 반환
    return await storageRef.getDownloadURL();
  }

  @override
  Future<FeedModel> createFeed({required FeedModel feed}) async {
    // Domain Model → DTO 변환
    final dto = FeedMapper.toDto(feed);

    // Firestore에 저장
    final docRef = await _firestore.collection('feeds').add(dto.toJson());
    final doc = await docRef.get();

    // DTO → Domain Model 변환 (생성된 문서 ID 포함)
    return FeedMapper.toDomain(FeedDto.fromDoc(doc));
  }


  @override
  Future<FeedModel> modifyFeed({required FeedModel feed}) async {
      // 1. Model을 DTO로 변환
      final dto = FeedMapper.toDto(feed);

      // 2. 문서 ID 확인 (수정하려면 ID가 반드시 있어야 함)
      if (feed.id == null) {
          throw Exception('수정할 피드의 ID가 누락되었습니다.'); 
      }

      // 3.  기존 문서 ID를 사용하여 UPDATE 실행
      await _firestore
          .collection('feeds')
          .doc(feed.id) 
          .update(dto.toJson()); 

      // 4. 업데이트된 문서를 다시 가져와 Model로 반환 (최종 확인)
      final doc = await _firestore.collection('feeds').doc(feed.id).get();

      // 5. DTO → Domain Model 변환 후 반환
      return FeedMapper.toDomain(FeedDto.fromDoc(doc));
  }
}