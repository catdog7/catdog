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
  int _feedViewKey = 0;

  @override
  void didUpdateWidget(NavigationBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 홈 탭으로 돌아올 때 HomeContent 강제 재생성 및 리프레시
    if (widget.selectedIndex == 0 && oldWidget.selectedIndex != 0) {
      // HomeContent가 재생성되도록 key 변경은 HomeView에서 처리됨
    }
    // 게시물 탭으로 변경될 때 FeedView 강제 재생성
    if (widget.selectedIndex == 1 && oldWidget.selectedIndex != 1) {
      setState(() {
        _feedViewKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.selectedIndex) {
      case 0:
        return HomeContent(key: widget.homeContentKey);
      case 1:
        return FeedView(key: ValueKey(_feedViewKey));
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
