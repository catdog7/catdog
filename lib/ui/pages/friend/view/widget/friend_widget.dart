import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/view/friend_home_test_view.dart';
import 'package:catdog/ui/widgets/more_widget.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final FriendInfoModel friend;
  final void Function(String id) onTap;
  const FriendWidget({super.key, required this.friend, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return FriendHomeTestView(friend);
                    },
                  ),
                );
              },
              child: Container(
                color: Colors.transparent,
                height: 40,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: friend.profileImageUrl != null
                          ? NetworkImage(friend.profileImageUrl!)
                          : AssetImage('assets/images/default_image.webp'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        friend.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          MoreWidget(
            menus: [
              MenuAction(title: '친구 취소', onTap: (_) => onTap(friend.userId)),
            ],
          ),
        ],
      ),
    );
  }
}
