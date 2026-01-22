import 'package:catdog/ui/pages/friend/view/friend_alarm_view.dart';
import 'package:catdog/ui/pages/home/view_model/friend_home_request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendRequestBtn extends HookConsumerWidget {
  const FriendRequestBtn({super.key, required this.friendId});
  final String friendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(friendHomeRequestViewModelProvider(friendId));
    final vm = ref.read(friendHomeRequestViewModelProvider(friendId).notifier);
    final isFriendLocal = useState(false);
    final isSendPendingLocal = useState(false);
    //final isReceivePendingLocal = useState(false);

    useEffect(() {
      state.whenOrNull(
        data: (data) {
          isFriendLocal.value = data.isFriend;
          isSendPendingLocal.value = data.isSendPending;
          //isReceivePendingLocal.value = data.isReceivePending;
        },
      );
      return null;
    }, [state.asData?.value]);

    return state.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: false,
      error: (error, _) => const SizedBox.shrink(),
      loading: () => Container(
        width: 84,
        height: 38,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF121416),
          ),
        ),
      ),
      data: (data) {
        return Row(
          children: [
            isFriendLocal.value
                ? InkWell(
                    onTap: () {
                      isFriendLocal.value = false;
                      isSendPendingLocal.value = false;
                      //isReceivePendingLocal.value = false;
                      vm.deleteFriend(friendId);
                    },
                    child: Container(
                      height: 38,
                      width: 84,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                      ),
                      child: Text(
                        "친구취소",
                        style: TextStyle(
                          color: const Color(0xFF666666),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                // : isReceivePendingLocal.value
                // ? InkWell(
                //     onTap: () {
                //       // 요청확인 누르면 친구 홈페이지 대신 알림 요청페이지 나타나도록
                //       if (context.mounted) {
                //         Navigator.of(context).pushReplacement(
                //           MaterialPageRoute(
                //             builder: (context) => const FriendAlarmPage(),
                //           ),
                //         );
                //       }
                //     },
                //     child: Container(
                //       height: 38,
                //       width: 84,
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         color: const Color(0xFFF2F2F2),
                //         border: Border.all(color: Color(0xFFF2F2F2)),
                //       ),
                //       child: Text(
                //         "요청확인",
                //         style: TextStyle(
                //           color: const Color(0xFFA9A9A9),
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   )
                : isSendPendingLocal.value
                ? Container(
                    height: 38,
                    width: 84,
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
                    onTap: () {
                      isFriendLocal.value = false;
                      isSendPendingLocal.value = true;
                      //isReceivePendingLocal.value = false;
                      vm.sendFollowRequest(friendId);
                    },
                    child: Container(
                      height: 38,
                      width: 84,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF121416),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "친구요청",
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(width: 20),
          ],
        );
      },
    );
  }
}
