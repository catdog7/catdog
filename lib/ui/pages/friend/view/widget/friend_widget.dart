import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/view_model/friend_view_model.dart';
import 'package:catdog/ui/pages/home/view/friend_home_view.dart';
import 'package:catdog/ui/widgets/more_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendWidget extends ConsumerWidget {
  final FriendInfoModel friend;
  final void Function(String id) onTap;
  const FriendWidget({super.key, required this.friend, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                //다른 사람 홈페이지 이동
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return FriendHomeView(friendUserId: friend.userId);
                    },
                  ),
                );
                if (!context.mounted) return;
                await ref.read(friendViewModelProvider.notifier).refresh();
              },
              child: Container(
                //color: Colors.transparent,
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
                        friend.nickname ?? '이름 없음',
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
