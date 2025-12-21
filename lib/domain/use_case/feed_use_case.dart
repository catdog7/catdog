import 'dart:io';

import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/domain/repository/feed_repository.dart';

/// Feed 관련 앱의 흐름/정책을 처리하는 UseCase
/// - 등록 시 createdAt, modifiedAt 자동 설정
/// - 태그 문자열을 리스트로 변환
/// - 이미지 업로드 처리
class FeedUseCase {
  const FeedUseCase({required this.feedRepo});
  final FeedRepository feedRepo;

  /// 피드 등록
  /// UseCase에서 앱의 정책을 처리:
  /// - 등록 시 createdAt, modifiedAt을 자동으로 설정
  /// - 태그 문자열을 리스트로 변환 (쉼표로 구분)
  /// - 이미지 업로드 처리
  Future<FeedModel> createFeed({
    required String writerId,
    required String nickname,
    required String tagString, // 쉼표로 구분된 태그 문자열
    required String content,
    required File imageFile, // 이미지 파일
  }) async {
    // 1. 이미지 업로드 (앱 정책: 피드 등록 시 이미지를 자동으로 업로드)
    final imageUrl = await feedRepo.uploadImage(
      imageFile: imageFile,
      writerId: writerId,
    );

    // 2. 태그 문자열을 리스트로 변환 (앱 정책: 쉼표로 구분, 빈 문자열 제거)
    final tagList = tagString
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();

    // 3. 현재 시간 설정 (앱 정책: 등록 시 createdAt, modifiedAt을 자동으로 설정)
    final now = DateTime.now();

    // 4. FeedModel 생성 (도메인 규칙 검증 포함)
    final feed = FeedModel.create(
      writerId: writerId,
      nickname: nickname,
      tag: tagList,
      content: content,
      imageUrl: imageUrl,
      createdAt: now,
      modifiedAt: now,
    );

    // 5. Repository에 저장
    return await feedRepo.createFeed(feed: feed);
  }

  Future<FeedModel> modifyFeed({
    required String id,
    required String writerId,
    required String nickname,
    required String tagString, // 쉼표로 구분된 태그 문자열
    required String content,
    required File imageFile, // 이미지 파일
    required DateTime existingCreatedAt,
  }) async {
    // 1. 이미지 업로드 (앱 정책: 피드 등록 시 이미지를 자동으로 업로드)
    final imageUrl = await feedRepo.uploadImage(
      imageFile: imageFile,
      writerId: writerId,
    );

    // 2. 태그 문자열을 리스트로 변환 (앱 정책: 쉼표로 구분, 빈 문자열 제거)
    final tagList = tagString
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();

    // 3. 현재 시간 설정 (앱 정책: 등록 시 createdAt, modifiedAt을 자동으로 설정)
    // final now = DateTime.now();

    // 4. FeedModel 생성 (도메인 규칙 검증 포함)
    final updatedFeed = FeedModel( 
        id: id, // ⭐️ ID를 넣어줍니다. RepositoryImpl이 이 ID로 문서를 찾습니다.
        writerId: writerId,
        nickname: nickname,
        tag: tagList,
        content: content,
        imageUrl: imageUrl, // 새로 업로드된 URL
        createdAt: existingCreatedAt,
        // ⭐️ 중요한 수정: modifiedAt만 현재 시간으로 설정
        modifiedAt: DateTime.now(), 
    );

    // 5. Repository에 저장
    return await feedRepo.modifyFeed(feed: updatedFeed);
  }

  /// 피드 수정 (이미지 변경 없이)
  /// 기존 이미지 URL을 그대로 사용
  Future<FeedModel> modifyFeedWithoutImage({
    required String id,
    required String writerId,
    required String nickname,
    required String tagString, // 쉼표로 구분된 태그 문자열
    required String content,
    required String existingImageUrl, // 기존 이미지 URL
    required DateTime existingCreatedAt,
  }) async {
    // 1. 태그 문자열을 리스트로 변환 (앱 정책: 쉼표로 구분, 빈 문자열 제거)
    final tagList = tagString
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();

    // 2. FeedModel 생성 (도메인 규칙 검증 포함)
    final updatedFeed = FeedModel(
      id: id,
      writerId: writerId,
      nickname: nickname,
      tag: tagList,
      content: content,
      imageUrl: existingImageUrl, // 기존 이미지 URL 사용
      createdAt: existingCreatedAt,
      modifiedAt: DateTime.now(), // modifiedAt만 현재 시간으로 설정
    );

    // 3. Repository에 저장
    return await feedRepo.modifyFeed(feed: updatedFeed);
  }
}

