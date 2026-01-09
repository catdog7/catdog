import 'dart:async';
import 'package:catdog/ui/pages/comment/view/comment_view.dart';
import 'package:catdog/ui/pages/friend/view/widget/friend_widget.dart';
import 'package:catdog/ui/pages/friend/view/widget/search_widget.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_search_view_model.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendSearchPage extends HookConsumerWidget {
  const FriendSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = useTextEditingController();
    final hasText = useState(false);
    final friendvm = ref.read(friendViewModelProvider.notifier);
    final state = ref.watch(friendSearchViewModelProvider);
    final followvm = ref.read(friendSearchViewModelProvider.notifier);
    final debounce = useRef<Timer?>(null);
    final isTyping = useState(false);

    void onSearchChanged(String value) {
      isTyping.value = true;
      debounce.value?.cancel();
      debounce.value = Timer(const Duration(milliseconds: 200), () async {
        await followvm.searchUsers(value);
        isTyping.value = false;
      });
    }

    useEffect(() {
      return () {
        debounce.value?.cancel();
      };
    }, []);

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
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "검색",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              leading: InkWell(
                onTap: () {
                  friendvm.refresh();
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_ios),
              ),
              ///////////코멘트 테스트하려고 만듦////////////////
              // actions: [
              //   InkWell(
              //     onTap: () {
              //       //
              //       showModalBottomSheet(
              //         context: context,
              //         isScrollControlled: true,
              //         backgroundColor: Colors.transparent,
              //         builder: (context) => CommentView(),
              //       );
              //     },
              //     child: Container(
              //       width: 35,
              //       height: 35,
              //       color: Colors.transparent,
              //       child: Icon(CupertinoIcons.bubble_middle_bottom),
              //     ),
              //   ),
              // ],
              ////////////////////////////////////////
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: hasText.value
                        ? Border.all(color: const Color(0xFFFDCA40), width: 2)
                        : Border.all(color: Colors.transparent, width: 2),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await followvm.searchUsers(searchText.text);
                        },
                        child: Container(
                          width: 35,
                          margin: EdgeInsets.only(right: 5),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchText,
                          autofocus: true,
                          cursorWidth: 1.5,
                          cursorColor: Colors.grey,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            isDense: true,
                            hint: Text(
                              "친구의 닉네임 또는 초대코드를 입력하세요",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            hasText.value = value.isNotEmpty;
                            onSearchChanged(value);
                          },
                          onSubmitted: (value) async {
                            await followvm.searchUsers(value);
                          },
                        ),
                      ),
                      hasText.value
                          ? InkWell(
                              onTap: () {
                                searchText.clear();
                                hasText.value = false;
                              },
                              child: Container(
                                width: 35,
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                !hasText.value
                    ? Expanded(
                        child: Column(
                          children: [
                            SizedBox(),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Container(
                            //       height: 36,
                            //       //color: Colors.amber,
                            //       alignment: Alignment.bottomLeft,
                            //       padding: EdgeInsets.only(left: 20, top: 10),
                            //       child: Text(
                            //         "최근검색",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           color: Colors.grey,
                            //           fontWeight: FontWeight.w600,
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       height: 36,
                            //       //color: Colors.amber,
                            //       alignment: Alignment.bottomLeft,
                            //       padding: EdgeInsets.only(right: 20, top: 10),
                            //       child: Text(
                            //         "모두 지우기",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           color: Colors.black,
                            //           fontWeight: FontWeight.w600,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      )
                    : isTyping.value
                    ? SizedBox()
                    : Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 36,
                                  alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "검색결과",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 36,
                                  alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    " ${data.users.length}건",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            data.users.isEmpty
                                ? Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error,
                                          size: 24,
                                          color: const Color(0xFFB2B2B2),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "검색결과가 없습니다.",
                                          style: TextStyle(
                                            color: const Color(0xFF666666),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                      ),
                                      child: ListView.builder(
                                        itemCount: data.users.length,
                                        itemBuilder: (context, index) {
                                          final user = data.users[index];
                                          if (user.isFriend) {
                                            return Container(
                                              height: 55,
                                              child: FriendWidget(
                                                friend: user,
                                                onTap: friendvm.deleteFriend,
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              height: 55,
                                              child: SearchWidget(
                                                user: user,
                                                onTap:
                                                    followvm.sendFollowRequest,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
