import 'dart:async';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/ui/pages/home/view/widget/home_stack.dart';
import 'package:amumal/ui/pages/home/view_model/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.user});

  final UserModel user;
  static String path = '/home';

  void onDeleteFeed(WidgetRef ref, String feedId) {
    ref.read(homeViewModelProvider.notifier).deleteFeed(feedId);
  }

  void onUpdateFeed(WidgetRef ref, String feedId) {
    ref.read(homeViewModelProvider.notifier).updateFeed(feedId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final isVisible = useState(false);

    final timer = useState<Timer?>(null);

    final state = ref.watch(homeViewModelProvider);
    final int currentPage = state.maybeWhen(
      data: (data) => data.currentPage,
      orElse: () => 0,
    );

    final syncCurrentPage = useCallback(() {
      if (pageController.hasClients && pageController.page != null) {
        Future.microtask(() {
          ref
              .read(homeViewModelProvider.notifier)
              .setCurrentPage(pageController.page!.round());
        });
      }
    }, [pageController, ref]);

    useEffect(() {
      pageController.addListener(syncCurrentPage);

      return () {
        pageController.removeListener(syncCurrentPage);
      };
    }, [pageController, syncCurrentPage]);

    // 피드리스트 길이를 30으로 고정하기 위해 인덱스가 바뀔 때
    useEffect(() {
      if (pageController.hasClients) {
        if (pageController.page!.round() != currentPage) {
          pageController.jumpToPage(currentPage);
        }
      }
      return null;
    }, [currentPage, pageController]);

    useEffect(() {
      return () {
        if (timer.value?.isActive ?? false) {
          timer.value?.cancel();
        }
      };
    }, [timer]);

    return state.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: false,
      loading: () => Center(
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => Text("에러: $error"),
      data: (data) {
        return NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollNotification) {
              const double visibilityThreshold = 400.0;
              final currentOffset = notification.metrics.pixels;

              // 1. 스크롤 위치 감지 및 버튼 표시
              if (currentOffset > visibilityThreshold) {
                // 스크롤이 움직이기 시작하면 타이머 취소 및 버튼 표시
                if (notification is ScrollUpdateNotification &&
                    !isVisible.value) {
                  timer.value?.cancel(); // 기존 숨김 타이머 취소
                  isVisible.value = true; // 버튼 표시
                }
              }

              // 스크롤 멈춤 감지 및 타이머 시작 (버튼 숨김 예약)
              if (notification is ScrollEndNotification) {
                // 스크롤이 끝났을 때만 타이머 시작
                timer.value?.cancel(); // 혹시 모를 이전 타이머 취소

                // 현재 offset이 임계값 이상인 경우에만 숨김 타이머 예약
                if (currentOffset > visibilityThreshold) {
                  timer.value = Timer(const Duration(milliseconds: 800), () {
                    isVisible.value = false;
                  });
                }
              }

              // 위치 복귀 시 즉시 숨김
              if (currentOffset < visibilityThreshold && isVisible.value) {
                isVisible.value = false;
                timer.value?.cancel(); // 타이머가 실행 중이라면 취소
              }
            }

            if (notification is ScrollUpdateNotification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent) {
                ref.read(homeViewModelProvider.notifier).fetchMore(limit: 10);
              }
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(homeViewModelProvider.notifier).refresh(limit: 10),
            child: Scaffold(
              body: PageView.builder(
                scrollDirection: Axis.vertical,
                controller: pageController,
                itemCount: data.feedList.length,
                itemBuilder: (context, index) {
                  final feed = data.feedList[index];
                  final writerId = feed.writerId;
                  final userId = user.id;
                  return HomeStack(
                    user: user,
                    feed: feed,
                    isWriter: userId == writerId,
                    onDelete: (id) => onDeleteFeed(ref, id),
                    onUpdate: (id) => onUpdateFeed(ref, id),
                  );
                },
              ),
              floatingActionButton: AnimatedOpacity(
                opacity: isVisible.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Visibility(
                  visible: isVisible.value,
                  child: FloatingActionButton.small(
                    backgroundColor: Color(0x55FFFFFF),
                    shape: const CircleBorder(),
                    onPressed: () {
                      pageController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          ),
        );
      },
    );
  }
}
