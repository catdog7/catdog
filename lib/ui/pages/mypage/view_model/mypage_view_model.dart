import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:catdog/ui/pages/mypage/state/mypage_state.dart';
import 'package:catdog/data/repository_impl/feed_repository_impl.dart';
import 'dart:io'; 
// ... 나머지 임포트들
part 'mypage_view_model.g.dart';

@riverpod
class MypageViewModel extends _$MypageViewModel {
  @override
  MypageState build() {
    // 뷰모델이 만들어지자마자 내 정보를 불러옵니다.
    Future.microtask(() => fetchMyData());
    return const MypageState();
  }

  Future<void> fetchMyData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final userData = await Supabase.instance.client
        .from('users') // Supabase의 유저 정보 테이블 이름
        .select()
        .eq('id', user.id)
        .single();

      // 1. 내 게시글만 가져오기 (FeedRepository 활용)
      final repository = ref.read(feedRepositoryProvider);
      final allFeeds = await repository.getFeeds();
      final myFeeds = allFeeds.where((feed) => feed.userId == user.id).toList();

        print("DB에서 가져온 유저 데이터: $userData");

      // 2. 상태 업데이트 (닉네임 등은 나중에 유저 테이블에서 가져오도록 확장 가능)
      state = state.copyWith(
      isLoading: false,
      nickname: userData['nickname'],
      inviteCode: userData['invite_code'],
      profileImageUrl: userData['profile_image_url'],
      myFeeds: myFeeds
    );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // lib/ui/pages/mypage/view_model/mypage_view_model.dart

Future<void> updateProfileImage(String imagePath) async {
  state = state.copyWith(isLoading: true);
  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final file = File(imagePath);
    final fileName = 'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // 1. Storage 업로드 프로파일로 변경
    await Supabase.instance.client.storage.from('profile_image').upload(fileName, file);
    final imageUrl = Supabase.instance.client.storage.from('profile_image').getPublicUrl(fileName);

    // 2. Users 테이블 업데이트
    await Supabase.instance.client
        .from('users')
        .update({'profile_image_url': imageUrl})
        .eq('id', user.id);

    // 3. 다시 데이터 불러오기
    await fetchMyData();
  } catch (e) {
    state = state.copyWith(isLoading: false, errorMessage: "이미지 변경 실패: $e");
  }
}
//마이페이지 수정 부분
Future<void> updateNickname(String newNickname) async {
  state = state.copyWith(isLoading: true);
  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Supabase DB 업데이트
    await Supabase.instance.client
        .from('users')
        .update({'nickname': newNickname})
        .eq('id', user.id);

    // 성공 시 상태 반영 및 다시 불러오기
    await fetchMyData();
  } catch (e) {
    state = state.copyWith(isLoading: false, errorMessage: "닉네임 수정 실패: $e");
  }
}
}