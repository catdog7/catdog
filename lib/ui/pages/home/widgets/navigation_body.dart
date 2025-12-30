import 'package:catdog/ui/pages/feed/view/feed_view.dart';
import 'package:catdog/ui/pages/friend/view/friend_view.dart';
import 'package:catdog/ui/pages/home/widgets/home_content.dart';
import 'package:catdog/ui/pages/mypage/mypage_view.dart';
import 'package:flutter/material.dart';

class NavigationBody extends StatelessWidget {
  final int selectedIndex;

  const NavigationBody({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const HomeContent();
      case 1:
        return const FeedView();
      // return const FeedPage();
      // return const Center(
      //   child: Text(
      //     '게시글 화면',
      //     style: TextStyle(fontSize: 24, color: Colors.black54),
      //   ),
      // );
      case 2:
        return FriendView();
      case 3:
        return const MypageView();
      default:
        return const Center(
          child: Text(
            '홈 화면',
            style: TextStyle(fontSize: 24, color: Colors.black54),
          ),
        );
    }
  }
}
