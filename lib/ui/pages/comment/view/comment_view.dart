import 'package:catdog/domain/model/comment_info_model.dart';
import 'package:catdog/ui/pages/comment/view/widget/comment_user_widget.dart';
import 'package:catdog/ui/pages/comment/view_model/comment_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class CommentView extends HookConsumerWidget {
  const CommentView({super.key, required this.feedId});
  final String feedId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(commentViewModelProvider(feedId));
    final vm = ref.read(commentViewModelProvider(feedId).notifier);
    final uuid = Uuid();
    final comment = useTextEditingController();

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sheetHeight = keyboardHeight > 0
        ? screenHeight * 0.47
        : screenHeight * 0.52;

    final scrollController = useScrollController();

    final showBackToTop = useState(false);
    final hasText = useState(false);
    final isSubmitting = useState<bool>(false);

    useEffect(() {
      void listener() {
        if (scrollController.offset > 300) {
          if (!showBackToTop.value) showBackToTop.value = true;
        } else {
          if (showBackToTop.value) showBackToTop.value = false;
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    useEffect(() {
      FirebaseAnalytics.instance.logScreenView(
        screenName: 'Comment_Sheet_View',
        screenClass: 'CommentView',
      );
      return null;
    }, []);

    // void scrollToTop() {
    //   // scrollController.animateTo(
    //   //   0,
    //   //   duration: const Duration(milliseconds: 500),
    //   //   curve: Curves.easeInOut,
    //   // );
    //   // 컨트롤러가 현재 스크롤 뷰에 붙어 있는지 확인
    //   if (scrollController.hasClients) {
    //     scrollController.animateTo(
    //       0,
    //       duration: const Duration(milliseconds: 300),
    //       curve: Curves.easeInOut,
    //     );
    //   } else {
    //     // 연결된 스크롤 뷰가 없을 때
    //     debugPrint("스크롤 컨트롤러가 아직 연결되지 않았습니다.");
    //   }
    // }

    return state.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: false,
      error: (error, _) => Text("에러: $error"),
      loading: () => Center(
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      data: (data) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: sheetHeight + keyboardHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    "댓글",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                data.comments.isNotEmpty
                    ? const Divider(
                        height: 1,
                        thickness: 1.5,
                        color: Color(0xFFF2F2F2),
                      )
                    : SizedBox(),
                Expanded(
                  child: data.comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "아직 댓글이 없어요",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "댓글을 남겨보세요!",
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: scrollController,
                          itemCount: data.comments.length,
                          itemBuilder: (context, index) {
                            final comment = data.comments[index];
                            return ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 66),
                              child: CommentUserWidget(
                                myId: data.myInfo?.id ?? "",
                                comment: comment,
                                onToggleLike: (commentId) {
                                  vm.onToggleLike(commentId);
                                },
                                onDeleted: (commentId) {
                                  print("vm deleteComment");
                                  vm.deleteComment(commentId);
                                },
                              ),
                            );
                          },
                        ),
                ),

                // 댓글 입력창
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFD9D9D9))),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                              'assets/images/default_image.webp',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: hasText.value
                                    ? Border.all(color: Color(0xFF666666))
                                    : Border.all(color: Color(0xFFD9D9D9)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                minLines: 1,
                                maxLines: 2,
                                controller: comment,
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  hasText.value = value.isNotEmpty;
                                },
                                onSubmitted: (value) async {
                                  if (isSubmitting.value ||
                                      value.trim().isEmpty)
                                    return;

                                  try {
                                    isSubmitting.value = true;

                                    await vm.addComment(
                                      CommentInfoModel(
                                        id: uuid.v4(),
                                        userId: data.myInfo?.id ?? "",
                                        nickname: data.myInfo?.nickname ?? "",
                                        content: value,
                                        isLike: false,
                                        likeCount: 0,
                                      ),
                                    );

                                    // 성공 시 초기화
                                    comment.clear();
                                    hasText.value = false;

                                    // 분석 이벤트 기록
                                    await FirebaseAnalytics.instance.logEvent(
                                      name: 'comment_add_success',
                                    );
                                  } catch (e) {
                                    debugPrint("댓글 등록 실패: $e");
                                  } finally {
                                    isSubmitting.value = false;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "댓글을 남겨보세요.",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFB3B3B3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: keyboardHeight),
              ],
            ),
          ),
        );
      },
    );
  }
}
