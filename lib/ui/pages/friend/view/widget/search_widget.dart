import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final FriendInfoModel user;
  final Function(String id) onTap;
  const SearchWidget({super.key, required this.user, required this.onTap});

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
          onTap: () async {
            final result = await onTap(user.userId);
            print("친구 요청 누름");
            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.nickname}에게 친구요청을 보냈습니다.')),
              );
            }
          },
          child: Container(
            height: 35,
            width: 75,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              "친구 요청",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
