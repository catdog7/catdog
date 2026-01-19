import 'dart:io';

import 'package:catdog/core/utils/compress_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedAddRepositoryImpl {
  //클래스를 만들면서 필요한 생성자 만들어주기
  final SupabaseClient _supabase;
  FeedAddRepositoryImpl(this._supabase);

  // 데이터를 보내는 함수이기 떄문에 Future붙여주면서 async, await붙여주기
  // 이미지와 내용을 업로드해주는 매서드 생성
  Future<void> uploadFeed(XFile image, String content) async {
    //유저 확인// curentUser를 쓴이유는 id만 지금 필요하기 떄문에
    final user = _supabase.auth.currentUser;
    // 더이상 진행되는 상황이 아닐떄 예외를 던져주는 코드
    if (user == null) throw Exception("로그인을 해주세요");

    try {
      final File originalFile = File(image.path);
      final File? compressedFile = await compressImage(originalFile);

      if (compressedFile == null) throw Exception("이미지 압축에 실패했습니다.");

      //1. storage 업로드 하기
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      //final bytes = await image.readAsBytes();
      //await _supabase.storage.from("feed_image").uploadBinary(fileName, bytes);

      await _supabase.storage
          .from("feed_image")
          .upload(
            fileName,
            compressedFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      //2 url 획득
      final imageUrl = _supabase.storage
          .from('feed_image')
          .getPublicUrl(fileName);
      //3 DB 저장
      await _supabase.from('feeds').insert({
        'content': content,
        'image_url': imageUrl,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (await compressedFile.exists()) {
        await compressedFile.delete();
      }
    } catch (e) {
      print("업로드 중 오류 발생: $e");
      rethrow;
    }
  }
}

// Riverpod으로 레파지토리 제공
final feedAddRepositoryProvider = Provider((ref) {
  final supabase = Supabase.instance.client;
  return FeedAddRepositoryImpl(supabase);
});
