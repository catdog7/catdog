import 'package:catdog/core/utils/debouncer.dart';
import 'package:catdog/domain/model/comment_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

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
                final result = await showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "게시물을 삭제하시겠어요?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                // 취소 버튼
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 50),
                                      side: const BorderSide(
                                        color: Color(0xFFE0E0E0),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "취소",
                                      style: TextStyle(
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // 삭제 버튼
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A1A1A),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(0, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("삭제"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (result) {
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
                      return;
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
                              return;
                            }
                            //다른 사람 홈페이지로 이동
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
                              Text(
                                DateFormat(
                                  ' MM월 dd일',
                                ).format(comment.createdAt ?? DateTime.now()),
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
                          ? Icon(
                              Icons.favorite,
                              size: 20,
                              color: Color(0xFFFCBC0D),
                            )
                          : Icon(
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
