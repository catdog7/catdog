import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/data/repository_impl/feed_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:catdog/ui/pages/feed/state/feed_state.dart';
import 'package:catdog/data/repository_impl/feed_add_repository_impl.dart';

part 'feed_view_model.g.dart';

@riverpod
class FeedViewModel extends _$FeedViewModel {
  @override
  FeedState build() {
    // 뷰모델이 생성되자마자 데이터를 불러오도록 설정합니다.
    Future.microtask(() => fetchFeedsForFriends());
    return  FeedState();
  }

  Future<void> fetchFeeds() async {
    // print("끼아ㅏ아아아아아아아ㅏ아아아ㅏㄱ되라고!1");

    // 1. 로딩 상태 시작
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // 2. Repository를 통해 Supabase에서 데이터 가져오기
      // (Repository에 getFeeds 메서드를 곧 만들 예정입니다.)
      final repository = ref.read(feedRepositoryProvider);
      final feeds = await repository.getFeeds(); 
      // print("끼아ㅏ아아아아아아아ㅏ아아아ㅏㄱ되라고!2");
      
      // 3. 성공 시 상태 업데이트
      state = state.copyWith(
        feeds: feeds, 
        isLoading: false
      );
    } catch (e) {
      // print("끼아ㅏ아아아아아아아ㅏ아아아ㅏㄱ되라고!3");

      // 4. 에러 발생 시 상태 업데이트
      state = state.copyWith(
        isLoading: false, 
        errorMessage: "피드를 불러오지 못했습니다: $e"
      );
    }
  }

  Future<void> fetchFeedsForFriends() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "로그인이 필요합니다."
        );
        return;
      }

      final friendUseCase = ref.read(friendUseCaseProvider);
      final friends = await friendUseCase.getMyFriends();
      final friendIds = friends.map((friend) => friend.userId).toList();

      final repository = ref.read(feedRepositoryProvider);
      final feeds = await repository.getFeedsForFriends(userId, friendIds);
      
      state = state.copyWith(
        feeds: feeds,
        isLoading: false
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "피드를 불러오지 못했습니다: $e"
      );
    }
  }
  //피드 삭제함수 
  Future<void> deleteFeed(String feedId) async {
  try {
    final repository = ref.read(feedRepositoryProvider);
    await repository.deleteFeed(feedId); // ✅ DB에서 먼저 지우고

    // ✅ 내 로컬 상태(리스트)에서도 해당 피드를 지워서 화면을 새로고침합니다.
    final updatedFeeds = state.feeds.where((feed) => feed.id != feedId).toList();
    state = state.copyWith(feeds: updatedFeeds);
    
    print("삭제 성공!");
  } catch (e) {
    print("삭제 중 에러 발생: $e");
    state = state.copyWith(errorMessage: "삭제에 실패했습니다.");
  }
}

//피드 수정 함수
// lib/ui/pages/feed/view_model/feed_view_model.dart

// ✅ newImagePath를 선택적 매개변수({ })로 추가합니다.
// lib/ui/pages/feed/view_model/feed_view_model.dart

Future<void> updateFeed(String feedId, String newContent, {String? newImagePath}) async {
  try {
    state = state.copyWith(isLoading: true); // 로딩 시작
    
    final repository = ref.read(feedRepositoryProvider);

    // Repository 호출 (이미지 경로 전달)
    await repository.updateFeed(feedId, newContent, newImagePath: newImagePath);

    // ✅ 전체 리스트를 다시 불러오거나(fetchFeedsForFriends), 로컬 상태를 영리하게 업데이트합니다.
    await fetchFeedsForFriends(); 
    
    print("수정 완료 및 새로고침 성공!");
  } catch (e) {
    state = state.copyWith(isLoading: false, errorMessage: "수정 실패: $e");
    print("수정 실패: $e");
  }
}
}