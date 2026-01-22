import 'dart:io';
import 'package:catdog/core/utils/compress_image.dart';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/domain/repository/feed_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // ✅ Ref를 사용하기 위해 추가
part 'feed_repository_impl.g.dart';

class FeedRepositoryImpl implements FeedRepository {
  final SupabaseClient _supabase;
  FeedRepositoryImpl(this._supabase);

  @override
  Future<List<FeedDto>> getFeeds() async {
    final userId = _supabase.auth.currentUser?.id;
    List<String> excludedFeedIds = [];
    List<String> excludedUserIds = [];

    if (userId != null) {
      // 1. 내가 신고한 피드 ID 가져오기
      final pd = await _supabase
          .from('reports')
          .select('target_id')
          .eq('reporter_id', userId)
          .eq('target_type', 'FEED');
      
      excludedFeedIds.addAll((pd as List).map((e) => e['target_id'] as String));

      // 2. 내가 차단한 유저 ID 가져오기
      final bd = await _supabase
          .from('blocks')
          .select('blocked_id')
          .eq('blocker_id', userId);
      
      excludedUserIds.addAll((bd as List).map((e) => e['blocked_id'] as String));
    }

    var query = _supabase.from('feeds').select();

    if (excludedFeedIds.isNotEmpty) {
      // not in filter (filter notation: 'id', 'not.in', list)
      // Supabase Flutter SDK .not('column', 'operator', value)
      // operator 'in' takes list.
      query = query.not('id', 'in', excludedFeedIds);
    }
    
    if (excludedUserIds.isNotEmpty) {
      query = query.not('user_id', 'in', excludedUserIds);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List).map((json) => FeedDto.fromJson(json)).toList();
  }

  @override
  Future<List<FeedDto>> getMyRecentFeeds(String userId) async {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    final response = await _supabase
        .from('feeds')
        .select()
        .eq('user_id', userId)
        .gte('created_at', oneWeekAgo.toIso8601String())
        .order('updated_at', ascending: false, nullsFirst: false)
        .order('created_at', ascending: false);

    final feeds = (response as List)
        .map((json) => FeedDto.fromJson(json))
        .toList();

    // 클라이언트 측에서 updatedAt 우선 정렬 (최신이 위로)
    feeds.sort((a, b) {
      final timeA = a.updatedAt ?? a.createdAt;
      final timeB = b.updatedAt ?? b.createdAt;
      if (timeA == null && timeB == null) return 0;
      if (timeA == null) return 1;
      if (timeB == null) return -1;
      return timeB.compareTo(timeA); // 내림차순
    });

    return feeds;
  }

  @override
  Future<List<FeedDto>> getFeedsForFriends(
    String userId,
    List<String> friendIds,
  ) async {
    final List<String> allowedUserIds = [userId, ...friendIds];

    if (allowedUserIds.isEmpty) {
      return [];
    }

    // 1. 제외할 피드 ID와 유저 ID 가져오기 ( 신고 / 차단 )
    List<String> excludedFeedIds = [];
    List<String> excludedUserIds = [];

    if (userId.isNotEmpty) {
      final pd = await _supabase
          .from('reports')
          .select('target_id')
          .eq('reporter_id', userId)
          .eq('target_type', 'FEED');
      excludedFeedIds.addAll((pd as List).map((e) => e['target_id'] as String));

      final bd = await _supabase
          .from('blocks')
          .select('blocked_id')
          .eq('blocker_id', userId);
      excludedUserIds.addAll((bd as List).map((e) => e['blocked_id'] as String));
    }

    // 2. 피드 데이터 가져오기 (전체 가져오기)
    String filterString = allowedUserIds
        .map((id) => 'user_id.eq.$id')
        .join(',');

    final response = await _supabase
        .from('feeds')
        .select()
        .or(filterString)
        .order('created_at', ascending: false);

    final feeds = (response as List).map((json) => FeedDto.fromJson(json)).toList();

    // 3. 메모리에서 필터링 (exclude logic)
    final filteredFeeds = feeds.where((feed) {
      final isReported = excludedFeedIds.contains(feed.id);
      final isBlocked = excludedUserIds.contains(feed.userId);
      return !isReported && !isBlocked;
    }).toList();

    return filteredFeeds;
  }

  //삭제 함수 기능
  @override
  Future<void> deleteFeed(String feedId) async {
    // Supabase의 'feeds' 테이블에서 id가 일치하는 행을 삭제합니다.
    await _supabase.from('feeds').delete().match({
      'id': feedId,
    }); //  여기서 id는 DB의 PK 컬럼 이름입니다.
  }

  //수정 기능
  @override
  // lib/data/repository_impl/feed_repository_impl.dart
  // lib/data/repository_impl/feed_repository_impl.dart
  @override
  Future<void> updateFeed(
    String feedId,
    String newContent, {
    String? newImagePath,
  }) async {
    String? finalImageUrl;

    // 1. 이미지 업로드 로직 (Bucket 이름도 다시 확인 필수!)
    if (newImagePath != null) {
      try {
        final file = File(newImagePath);

        // ✅ 압축 실행: _compressImage 함수를 호출합니다.
        final File? compressedFile = await compressImage(file);

        if (compressedFile == null) throw Exception("이미지 압축에 실패했습니다.");

        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

        // ⚠️ Supabase Storage에 'feed_image'라는 이름의 Bucket이 실제로 있는지 꼭 확인하세요!
        //await _supabase.storage.from('feed_image').upload(fileName, file);

        // ✅ 압축된 파일(compressedFile)을 업로드합니다.
        await _supabase.storage
            .from('feed_image')
            .upload(
              fileName,
              compressedFile,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        finalImageUrl = _supabase.storage
            .from('feed_image')
            .getPublicUrl(fileName);
        print(finalImageUrl + "들어가지나들어가지나들어가지나들어가지나들어가지나들어가지나들어가지나들어가지나");

        if (await compressedFile.exists()) {
          await compressedFile.delete();
        }
      } catch (e) {
        debugPrint("이미지 처리 중 에러: $e");
        rethrow; // 에러를 위로 던져 View에서 로딩 상태를 해제할 수 있게 함
      }
    }

    // 2. 업데이트 데이터 구성
    final Map<String, dynamic> updateData = {'content': newContent};

    // ✅ DB 대시보드에 적힌 'imago_url'로 이름을 맞춰줍니다.
    if (finalImageUrl != null) {
      updateData['image_url'] = finalImageUrl;
    }

    // 3. 실행
    await _supabase.from('feeds').update(updateData).match({'id': feedId});
  }
}

// ✅ Provider 생성 (ViewModel에서 쓸 수 있도록)
@riverpod
FeedRepository feedRepository(Ref ref) {
  return FeedRepositoryImpl(Supabase.instance.client);
}
