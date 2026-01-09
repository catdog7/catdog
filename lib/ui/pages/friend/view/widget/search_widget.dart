import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:catdog/ui/pages/friend/view/friend_home_test_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchWidget extends HookWidget {
  final FriendInfoModel user;
  final Function(String id) onTap;
  const SearchWidget({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final clicked = useState(false);
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
                      return FriendHomeTestView(user);
                    },
                  ),
                );
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : AssetImage('assets/images/default_image.webp'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.nickname,
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
          user.status == "PENDING" || clicked.value
              ? Container(
                  height: 38,
                  width: 71,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFF2F2F2),
                    border: Border.all(color: Color(0xFFF2F2F2)),
                  ),
                  child: Text(
                    "요청됨",
                    style: TextStyle(
                      color: const Color(0xFFA9A9A9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () async {
                    print("친구 요청 누름");
                    print("user status!!!!! : ${user.status}");
                    clicked.value = true;
                    final result = await onTap(user.userId);
                    String message = "";
                    if (result == "SUCCESS") {
                      message = '님에게 친구를 요청 했습니다.';
                    } else if (result == "FRIEND") {
                      message = '이미 친구 목록에 있습니다.';
                    } else {
                      message = '잠시후 다시 시도해주세요';
                    }
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
                            result == "SUCCESS"
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  )
                                : const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 12),
                            result == "SUCCESS"
                                ? Flexible(
                                    child: Text(
                                      '${user.nickname ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : SizedBox(),
                            Text(message),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 38,
                    width: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                    ),
                    child: Text(
                      "친구 요청",
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
