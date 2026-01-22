import 'package:catdog/ui/pages/friend/view/widget/alarm_widget.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_alarm_view_model.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendAlarmPage extends HookConsumerWidget {
  const FriendAlarmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(friendAlarmViewModelProvider);
    final vm = ref.read(friendAlarmViewModelProvider.notifier);
    final friendvm = ref.read(friendViewModelProvider.notifier);

    useEffect(() {
      FirebaseAnalytics.instance.logScreenView(
        screenName: 'Friend_Request_List_View',
        screenClass: 'FriendRequestView',
      );

      final subscription = FirebaseMessaging.onMessage.listen((message) {
        vm.refresh();
      });

      return () => subscription.cancel();
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
            centerTitle: true,
            title: Text(
              "친구요청",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            leading: InkWell(
              onTap: () {
                friendvm.refresh();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: data.friends.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 24,
                        color: const Color(0xFFB2B2B2),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "친구 요청이 없습니다.",
                        style: TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 100,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 36,
                            child: Text(
                              "총",
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ),
                          Container(
                            height: 36,
                            alignment: Alignment.center,
                            child: Text(
                              " ${data.friends.length}건",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.friends.length,
                          itemBuilder: (context, index) {
                            final user = data.friends[index];
                            return AlarmWidget(
                              user: user,
                              onDeleted: vm.rejectRequest,
                              onAccepted: vm.acceptFollowRequest,
                            );
                          },
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
