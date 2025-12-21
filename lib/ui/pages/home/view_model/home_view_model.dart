import 'package:amumal/core/config/home_dependency.dart';
import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/ui/pages/home/state/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    final (feedList, lastDocument) = await ref
        .watch(homeUseCaseProvider)
        .fetchInitial(limit: 10);

    return HomeState(
      feedList: feedList,
      lastDocument: lastDocument,
      currentPage: 0,
      isLastPage: false,
      isLoading: false,
      isRefreshing: false,
    );
  }

  // // 처음 10개, pull to refresh에 쓰기
  Future<void> refresh({required int limit}) async {
    if (state.value == null || state.value!.isRefreshing) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isRefreshing: true));
    try {
      final usecase = ref.read(homeUseCaseProvider);
      final (feedList, lastDocument) = await usecase.fetchInitial(limit: limit);
      state = AsyncData(
        state.value!.copyWith(
          feedList: feedList,
          lastDocument: lastDocument,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isRefreshing: false));
    }
  }

  // // 그 후에 더 가져오기 무한 스크롤
  Future<void> fetchMore({required int limit}) async {
    if (state.value == null ||
        state.value!.isLoading ||
        state.value!.lastDocument == null) {
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));
    try {
      final usecase = ref.read(homeUseCaseProvider);
      var (feedList, lastDocument) = await usecase.fetchMore(
        limit: limit,
        lastDocument: state.value!.lastDocument!,
      );

      // 더 가져올 데이터 없으면 fetchInitial로 가져온 피드 붙이기
      if (feedList.isEmpty) {
        (feedList, lastDocument) = await usecase.fetchInitial(limit: 10);
      }

      final startIndex = state.value!.feedList.length - (30 - feedList.length);
      final start = startIndex < 0 ? 0 : startIndex;
      final newList = [...state.value!.feedList.sublist(start), ...feedList];

      final newCurrentPage = start > 0
          ? state.value!.currentPage - feedList.length
          : state.value!.currentPage;

      state = AsyncData(
        state.value!.copyWith(
          feedList: newList,
          lastDocument: lastDocument,
          isLoading: false,
          currentPage: newCurrentPage,
        ),
      );
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLoading: false));
    }
  }

  Future<void> deleteFeed(String feedId) async {
    if (state.value == null || state.value!.feedList.isEmpty) {
      print("delete불가");
      return;
    }
    final usecase = ref.read(homeUseCaseProvider);

    // 로컬 리스트에서 삭제할 항목의 인덱스 찾기
    final indexToDelete = state.value!.feedList.indexWhere(
      (feed) => feed.id == feedId,
    );
    if (indexToDelete == -1) return; // 로컬 리스트에 없으면 종료

    // Firestore에서 문서 삭제
    try {
      final result = await usecase.deleteFeed(feedId: feedId);
      if (!result) {
        throw Exception();
      }
    } catch (e) {
      print('Firestore 문서 삭제 오류: $e');
      // 사용자에게 오류 알림 후 종료
      return;
    }

    // 삭제 성공 후 로컬 상태 갱신
    final newFeeds = List<FeedModel>.from(state.value!.feedList);
    newFeeds.removeAt(indexToDelete);

    int newCurrentPage;

    if (newFeeds.isEmpty) {
      newCurrentPage = 0;
    } else if (indexToDelete >= newFeeds.length) {
      // 마지막 페이지를 삭제한 경우: 이전 페이지로 이동
      newCurrentPage = newFeeds.length - 1;
    } else {
      // 중간 페이지를 삭제한 경우: 다음 페이지가 현재 인덱스 위치로 이동
      newCurrentPage = indexToDelete;
    }

    final isLast =
        newCurrentPage == (newFeeds.isEmpty ? 0 : newFeeds.length - 1);

    state = AsyncData(
      state.value!.copyWith(
        feedList: newFeeds,
        currentPage: newCurrentPage,
        isLastPage: isLast,
      ),
    );
  }

  void setCurrentPage(int index) {
    if (state.value == null ||
        index < 0 ||
        index >= state.value!.feedList.length) {
      return;
    }

    final isLast = index == state.value!.feedList.length - 1;

    state = AsyncData(
      state.value!.copyWith(currentPage: index, isLastPage: isLast),
    );
  }

  Future<void> updateFeed(String id) async {
    if (state.value == null || state.value!.feedList.isEmpty) {
      print("update 불가");
      return;
    }
    state = AsyncData(state.value!.copyWith(isLoading: true));

    final usecase = ref.read(homeUseCaseProvider);
    final index = state.value!.feedList.indexWhere((feed) => feed.id == id);
    if (index == -1) return;

    try {
      final result = await usecase.getFeed(id: id);
      if (result == null) {
        state = AsyncData(state.value!.copyWith(isLoading: false));
        return;
      }
      final newList = state.value!.feedList.toList();
      newList[index] = result;
      state = AsyncData(
        state.value!.copyWith(feedList: newList, isLoading: false),
      );
    } catch (e) {
      print('Firestore 문서 수정 오류: $e');
      state = AsyncData(state.value!.copyWith(isLoading: false));
      return;
    }
  }
}
