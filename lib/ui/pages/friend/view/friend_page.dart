import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/domain/model/friend_model.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/ui/pages/friend/view/friend_alarm_page.dart';
import 'package:catdog/ui/pages/friend/view/friend_search_page.dart';
import 'package:catdog/ui/pages/friend/view/widget/friend_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class FriendPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uuid = const Uuid();
    final client = ref.read(supabaseClientProvider);
    final myId = client.auth.currentUser?.id;
    final user = UserModel(
      id: 'adfadfadf',
      nickname: '콩이',
      inviteCode: 'ㅁㅇㄹㅁㅇㄹ',
      profileImageUrl: 'https://picsum.photos/200/300',
    );

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
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
      body: Center(
        child: Column(
          children: [
            // InkWell(
            //   onTap: () async {
            //     //await ref.read(friendRepositoryProvider).addFriend(FriendModel(id: uuid.v4(), userAId: myId!, userBId: userBId));
            //   },
            // ),
            Container(height: 8, color: Colors.grey[200]),
            Row(
              children: [
                Container(
                  height: 36,
                  //color: Colors.amber,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "총",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 36,
                  //color: Colors.amber,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    " n명",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [FriendWidget(user)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
