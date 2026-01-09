import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:flutter/material.dart';

class FriendHomeTestView extends StatelessWidget {
  final FriendInfoModel friend;
  FriendHomeTestView(this.friend);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(friend.nickname)),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: friend.profileImageUrl != null
                  ? NetworkImage(friend.profileImageUrl!)
                  : AssetImage('assets/images/default_image.webp'),
            ),
            Text("id : ${friend.userId}"),
            Text("nickname : ${friend.nickname}"),
            Text("isFriend : ${friend.isFriend}"),
            Text("Status : ${friend.status}"),
          ],
        ),
      ),
    );
  }
}
