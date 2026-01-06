import 'package:catdog/ui/pages/feed/view/feed_view.dart';
import 'package:catdog/ui/pages/friend/view/friend_view.dart';
import 'package:catdog/ui/pages/home/widgets/home_content.dart';
import 'package:catdog/ui/pages/mypage/mypage_view.dart';
import 'package:flutter/material.dart';

class NavigationBody extends StatefulWidget {
  final int selectedIndex;
  final Key? homeContentKey;

  const NavigationBody({super.key, required this.selectedIndex, this.homeContentKey});

  @override
  State<NavigationBody> createState() => NavigationBodyState();
}

class NavigationBodyState extends State<NavigationBody> {
  @override
  Widget build(BuildContext context) {
    switch (widget.selectedIndex) {
      case 0:
        return HomeContent(key: widget.homeContentKey);
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
