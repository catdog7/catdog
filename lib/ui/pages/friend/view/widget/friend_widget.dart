import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/ui/widgets/more_widget.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final UserModel user;
  const FriendWidget(this.user);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: user.profileImageUrl != null
              ? NetworkImage(user.profileImageUrl!)
              : null,
        ),
        SizedBox(width: 8),
        Expanded(child: Text(user.nickname)),
        MoreWidget(
          menus: [
            MenuAction(title: '친구 취소', onTap: (_) => print("친구 취소 누름")),
            MenuAction(title: '친구 차단', onTap: (_) => print("친구 차단 누름")),
            MenuAction(title: '친구 삭제', onTap: (_) => print("친구 삭제 누름")),
            MenuAction(title: '친구 거절', onTap: (_) => print("친구 거절 누름")),
          ],
        ),
      ],
    );
  }
}
