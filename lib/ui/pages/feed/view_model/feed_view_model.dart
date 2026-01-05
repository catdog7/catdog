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
    Future.microtask(() => fetchFeeds());
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
}