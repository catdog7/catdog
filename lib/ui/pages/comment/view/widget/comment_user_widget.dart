import 'package:catdog/core/utils/debouncer.dart';
import 'package:catdog/core/utils/time_formatter.dart';
import 'package:catdog/domain/model/comment_info_model.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/home/view/friend_home_view.dart';
import 'package:catdog/ui/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommentUserWidget extends HookWidget {
  const CommentUserWidget({
    super.key,
    required this.myId,
    required this.comment,
    required this.onToggleLike,
    required this.onDeleted,
  });
  final String myId;
  final CommentInfoModel comment;
  final Function(String commentId) onToggleLike;
  final Function(String commentId) onDeleted;
  @override
  Widget build(BuildContext context) {
    late String editedNickname;
    editedNickname = comment.nickname.length > 15
        ? '${comment.nickname.substring(0, 15)}...'
        : comment.nickname;

    final likeUI = useState(comment.isLike);
    final likeCountUI = useState(comment.likeCount);

    useEffect(() {
      likeUI.value = comment.isLike;
      likeCountUI.value = comment.likeCount;
      return null;
    }, [comment.id, comment.isLike, comment.likeCount]);

    final debouncer = useMemoized(
      () => Debouncer(
        duration: const Duration(milliseconds: 500),
        callback: () {
          onToggleLike(comment.id);
        },
      ),
    );

    useEffect(() => debouncer.dispose, [debouncer]);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: myId == comment.userId
            ? () async {
                final result = await DeleteDialog.show(
                  context: context,
                  title: '댓글을 삭제하시겠습니까?',
                );
                if (result == true) {
                  print("삭제 팝업 결과 true");
                  onDeleted(comment.id);
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          height: 66,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    //다른 사람 홈페이지로 이동
                    if (myId == comment.userId) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeView(initialIndex: 0),
                        ),
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              FriendHomeView(friendUserId: comment.userId),
                        ),
                      );
                    }
                    print("사진 눌러서 홈페이지 이동");
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          'assets/images/default_image.webp',
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 22,
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (myId == comment.userId) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeView(initialIndex: 0),
                                ),
                                (route) => false,
                              );
                            } else {
                              //다른 사람 홈페이지로 이동
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FriendHomeView(
                                    friendUserId: comment.userId,
                                  ),
                                ),
                              );
                            }
                            print("${editedNickname}의 홈페이지로 이동");
                          },
                          child: Row(
                            children: [
                              Text(
                                editedNickname,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(" "),
                              Text(
                                TimeFormatter.formatRelativeTime(
                                  comment.createdAt,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFB3B3B3),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsGeometry.only(right: 20),
                        child: Text(
                          comment.content,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 좋아요
                GestureDetector(
                  onTap: () {
                    likeUI.value = !likeUI.value;
                    if (likeUI.value) {
                      likeCountUI.value++;
                    } else {
                      likeCountUI.value--;
                    }
                    debouncer.run();
                  },
                  child: Column(
                    children: [
                      likeUI.value
                          ? const Icon(
                              Icons.favorite,
                              size: 20,
                              color: Color(0xFFFCBC0D),
                            )
                          : const Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Color(0xFFB3B3B3),
                            ),
                      Text(
                        likeCountUI.value == 0 ? " " : "${likeCountUI.value}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFB3B3B3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
