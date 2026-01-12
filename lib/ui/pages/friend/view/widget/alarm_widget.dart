import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/view/friend_home_test_view.dart';
import 'package:flutter/material.dart';

class AlarmWidget extends StatelessWidget {
  final FriendInfoModel user;
  final void Function(String id) onDeleted;
  final void Function(String id) onAccepted;
  const AlarmWidget({
    super.key,
    required this.user,
    required this.onDeleted,
    required this.onAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          //다른 사람 홈페이지 이동
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FriendHomeTestView(user);
              },
            ),
          );
        },
        child: Row(
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
            InkWell(
              onTap: () {
                onDeleted(user.userId);
                //print("친구 요청 삭제");
              },
              child: Container(
                height: 35,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: Text(
                  "삭제",
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Ink(
              decoration: BoxDecoration(
                color: const Color(0xFF121416),
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                onTap: () {
                  onAccepted(user.userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF575E6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(20),
                      duration: const Duration(seconds: 2),
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              '${user.nickname ?? ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text("님의 친구 요청을 수락 했습니다."),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 35,
                  width: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xFF121416)),
                  ),
                  child: Text(
                    "친구 수락",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
