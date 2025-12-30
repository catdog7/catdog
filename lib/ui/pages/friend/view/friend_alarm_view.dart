import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/ui/pages/friend/view/widget/alarm_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendAlarmPage extends ConsumerWidget {
  FriendAlarmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FriendInfoModel(
      userId: 'adfadfadf',
      nickname: '콩이',
      profileImageUrl: 'https://picsum.photos/200/300',
      isFriend: false,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "친구요청",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 20,
                  child: Text(
                    "총",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Container(
                  height: 20,
                  child: Text(
                    " n건",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 65,
                    child: AlarmWidget(
                      user: user,
                      onDeleted: (_) => print("삭제 누름"),
                      onAccepted: (_) => print("친구 요청 누름"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
