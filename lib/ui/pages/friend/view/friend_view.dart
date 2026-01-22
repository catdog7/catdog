import 'package:catdog/ui/pages/friend/view/friend_alarm_view.dart';
import 'package:catdog/ui/pages/friend/view/friend_search_view.dart';
import 'package:catdog/ui/pages/friend/view/widget/friend_widget.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_alarm_view_model.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(friendViewModelProvider);
    final vm = ref.read(friendViewModelProvider.notifier);
    final alarm = ref.watch(friendAlarmViewModelProvider);

    final hasAlarm = alarm.when(
      data: (list) => list.friends.isNotEmpty,
      loading: () => false,
      error: (_, __) => false,
    );

    useEffect(() {
      final subscription = FirebaseMessaging.onMessage.listen((message) {
        ref.read(friendViewModelProvider.notifier).refresh();
      });
      return subscription.cancel; // 위젯 제거 시 리스너 해제
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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "친구",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return FriendSearchPage();
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Icon(Icons.search),
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(friendAlarmViewModelProvider.notifier).refresh();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return FriendAlarmPage();
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  child: Stack(
                    children: [
                      Container(
                        child: Icon(
                          Icons.notifications_none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasAlarm ? Colors.red : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: data.friends.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/icon_freind_on.svg',
                        width: 50,
                        height: 50,
                        colorFilter: ColorFilter.mode(
                          Color(0xFFB2B2B2),
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        "아직 친구가 없어요.",
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "지금 친구를 등록하고 일상을 공유해봐요!",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Ink(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDCA40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FriendSearchPage();
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 46,
                            width: 112,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFDCA40),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "등록하기 ",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      Container(height: 8, color: Color(0xFFF8FAFE)),
                      SizedBox(height: 8),
                      Container(
                        height: 36,
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 20,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              "총",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              " ${data.friends.length}명",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.builder(
                            itemCount: data.friends.length,
                            itemBuilder: (context, index) {
                              final friend = data.friends[index];
                              return FriendWidget(
                                friend: friend,
                                onTap: vm.deleteFriend,
                              );
                            },
                          ),
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
