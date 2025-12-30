import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:flutter/material.dart';

class AlarmWidget extends StatelessWidget {
  final FriendInfoModel user;
  final void Function(String id) onDeleted;
  final void Function(String id) onAccepted;
  const AlarmWidget({
    super.key,
    required this.user,
    required this.onDeleted,
    required this.onAccepted,
  });

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
        Expanded(
          child: Text(
            user.nickname,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        InkWell(
          onTap: () {
            onDeleted(user.userId);
            //print("친구 요청 삭제");
          },
          child: Container(
            height: 35,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              "삭제",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(width: 5),
        Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFFDCA40),
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              onAccepted(user.userId);
              //print("친구 요청 수락");
            },
            child: Container(
              height: 35,
              width: 75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFFFDCA40)),
              ),
              child: Text("친구 수락", style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }
}
