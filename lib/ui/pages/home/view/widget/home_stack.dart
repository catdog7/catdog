import 'package:amumal/core/theme/fixed_colors.dart';
import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum MenuItem { write, edit, delete }

class HomeStack extends HookWidget {
  const HomeStack({
    super.key,
    required this.user,
    required this.feed,
    required this.isWriter,
    required this.onDelete,
    required this.onUpdate,
  });
  final UserModel user;
  final FeedModel feed;
  final bool isWriter;
  final void Function(String feedId) onDelete;
  final void Function(String feedId) onUpdate;

  @override
  Widget build(BuildContext context) {
    String tags = feed.tag.map((e) => '#$e').join();
    final isImageLoaded = useState(false);

    final textContent = SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 20),
            width: double.infinity,
            height: 50,
            color: Colors.transparent,
            child: PopupMenuButton<MenuItem>(
              icon: Icon(
                Icons.more_horiz,
                color: FixedColors.constant.activeColor,
                size: 32,
              ),
              constraints: const BoxConstraints(maxWidth: 80),

              itemBuilder: (BuildContext context) {
                List<PopupMenuEntry<MenuItem>> menuItems = [
                  const PopupMenuItem<MenuItem>(
                    height: 30,
                    value: MenuItem.write,
                    child: Text('글 작성'),
                  ),
                ];

                // isWriter가 true일 경우에만 수정/삭제 옵션을 추가합니다.
                if (isWriter) {
                  menuItems.add(
                    const PopupMenuItem<MenuItem>(
                      height: 30,
                      value: MenuItem.edit,
                      child: Text('글 수정'),
                    ),
                  );
                  menuItems.add(
                    const PopupMenuItem<MenuItem>(
                      height: 30,
                      value: MenuItem.delete,
                      child: Text('글 삭제'),
                    ),
                  );
                }
                return menuItems;
              },

              onSelected: (MenuItem result) {
                switch (result) {
                  case MenuItem.write:
                    // 글 작성 로직 실행 (예: 새 화면으로 이동)
                    print('글 작성 선택됨');
                    print("Feed Id : ${feed.id}");
                    context.push('/feed', extra: user);
                    break;
                  case MenuItem.edit:
                    // 글 수정 로직 실행
                    if (!isWriter) {
                      return;
                    }
                    print('글 수정 선택됨');
                    context
                        .push(
                          '/feed/${feed.id}/edit',
                          extra: {'user': user, 'feed': feed},
                        )
                        .then((Value) {
                          onUpdate(feed.id!);
                        });
                    break;
                  case MenuItem.delete:
                    // 글 삭제 로직 실행 (예: 확인 다이얼로그 띄우기)
                    if (!isWriter) {
                      return;
                    }
                    onDelete(feed.id!);
                    print('글 삭제 선택됨');

                    break;
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tags,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        // 아래쪽 테두리
                        Shadow(offset: Offset(0, 1), color: Colors.black),
                        // 위쪽 테두리
                        Shadow(offset: Offset(0, -1), color: Colors.black),
                        // 오른쪽 테두리
                        Shadow(offset: Offset(1, 0), color: Colors.black),
                        // 왼쪽 테두리
                        Shadow(offset: Offset(-1, 0), color: Colors.black),
                        Shadow(
                          offset: Offset(0, 0),
                          color: Colors.white,
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      shadows: [
                        // 아래쪽 테두리
                        Shadow(offset: Offset(0, 1), color: Colors.black),
                        // 위쪽 테두리
                        Shadow(offset: Offset(0, -1), color: Colors.black),
                        // 오른쪽 테두리
                        Shadow(offset: Offset(1, 0), color: Colors.black),
                        // 왼쪽 테두리
                        Shadow(offset: Offset(-1, 0), color: Colors.black),
                        Shadow(
                          offset: Offset(0, 0),
                          color: Colors.white,
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      feed.content,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 50,
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  // 피드 작성 시간
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        shadows: [
                          // 아래쪽 테두리
                          Shadow(offset: Offset(0, 0.5), color: Colors.black),
                          // 위쪽 테두리
                          Shadow(offset: Offset(0, -0.5), color: Colors.black),
                          // 오른쪽 테두리
                          Shadow(offset: Offset(0.5, 0), color: Colors.black),
                          // 왼쪽 테두리
                          Shadow(offset: Offset(-0.5, 0), color: Colors.black),
                          Shadow(
                            offset: Offset(0, 0),
                            color: Colors.white,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        DateFormat('yyyy.MM.dd HH:mm').format(feed.createdAt),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // 댓글 작성 페이지로 이동
                    context.push('/comment/${feed.id}', extra: user);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      CupertinoIcons.chat_bubble_fill,
                      color: FixedColors.constant.activeColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              feed.imageUrl,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (frame != null) {
                  if (!isImageLoaded.value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        isImageLoaded.value = true;
                      }
                    });
                  }
                  return child;
                }
                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [const CircularProgressIndicator()],
                  ),
                );
              },
            ),
          ),

          if (isImageLoaded.value) Positioned.fill(child: textContent),
        ],
      ),
    );
  }
}
