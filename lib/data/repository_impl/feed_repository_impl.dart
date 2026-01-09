import 'dart:io'; 
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/domain/repository/feed_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // ✅ Ref를 사용하기 위해 추가
part 'feed_repository_impl.g.dart';
class FeedRepositoryImpl implements FeedRepository {
  final SupabaseClient _supabase;
  FeedRepositoryImpl(this._supabase);

  @override
  Future<List<FeedDto>> getFeeds() async {
    final response = await _supabase
        .from('feeds')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => FeedDto.fromJson(json)).toList();
  }
  //삭제 함수 기능
  @override
Future<void> deleteFeed(String feedId) async {
  // Supabase의 'feeds' 테이블에서 id가 일치하는 행을 삭제합니다.
  await _supabase
      .from('feeds')
      .delete()
      .match({'id': feedId}); //  여기서 id는 DB의 PK 컬럼 이름입니다.
}
//수정 기능
@override
// lib/data/repository_impl/feed_repository_impl.dart

// lib/data/repository_impl/feed_repository_impl.dart

@override
Future<void> updateFeed(String feedId, String newContent, {String? newImagePath}) async {
  String? finalImageUrl;

  // 1. 이미지 업로드 로직 (Bucket 이름도 다시 확인 필수!)
  if (newImagePath != null) {
    final file = File(newImagePath);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // ⚠️ Supabase Storage에 'feed_image'라는 이름의 Bucket이 실제로 있는지 꼭 확인하세요!
    await _supabase.storage.from('feed_image').upload(fileName, file);
    finalImageUrl = _supabase.storage.from('feed_image').getPublicUrl(fileName);
    print(finalImageUrl+"들어가지나들어가지나들어가지나들어가지나들어가지나들어가지나들어가지나들어가지나");
  }

  // 2. 업데이트 데이터 구성
  final Map<String, dynamic> updateData = {'content': newContent};
  
  // ✅ DB 대시보드에 적힌 'imago_url'로 이름을 맞춰줍니다.
  if (finalImageUrl != null) {
    updateData['image_url'] = finalImageUrl; 
  }

  // 3. 실행
  await _supabase
      .from('feeds')
      .update(updateData)
      .match({'id': feedId});
}
}
 
// ✅ Provider 생성 (ViewModel에서 쓸 수 있도록)
@riverpod
FeedRepository feedRepository(Ref ref) {
  return FeedRepositoryImpl(Supabase.instance.client);
}