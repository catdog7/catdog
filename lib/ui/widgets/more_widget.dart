import 'package:flutter/material.dart';

class MenuAction<T> {
  final String title;
  final void Function(T value) onTap;

  const MenuAction({required this.title, required this.onTap});
}

//사용 예시
// MoreWidget(
//   menus: [
//     MenuAction(title: '친구 취소', onTap: (_) => print("친구 취소 누름")),
//     MenuAction(title: '친구 차단', onTap: (_) => print("친구 차단 누름")),
//     MenuAction(title: '친구 삭제', onTap: (_) => print("친구 삭제 누름")),
//     MenuAction(title: '친구 거절', onTap: (_) => print("친구 거절 누름")),
//   ],
// ),

class MoreWidget extends StatelessWidget {
  final List<MenuAction> menus;

  const MoreWidget({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (menu) => menu.onTap(menu),
      itemBuilder: (BuildContext context) {
        final List<PopupMenuEntry<MenuAction>> items = [];

        for (int i = 0; i < menus.length; i++) {
          items.add(
            PopupMenuItem<MenuAction>(
              value: menus[i],
              height: 30,
              child: Center(child: Text(menus[i].title)),
            ),
          );

          // 마지막 아이템이 아니면 divider 추가
          if (i != menus.length - 1) {
            items.add(const PopupMenuDivider());
          }
        }

        return items;
      },
      child: Container(
        width: 40,
        alignment: Alignment.centerRight,
        child: Icon(Icons.more_vert),
      ),
    );
  }
}
