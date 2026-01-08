import 'package:catdog/ui/pages/comment/view/widget/comment_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//수정중
class CommentView extends HookConsumerWidget {
  CommentView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comment = useTextEditingController();
    final message1 =
        """초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초
        코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다..."""
            .replaceAll('\n', '');
    final message2 = "진짜";
    final message3 =
        """초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초
        코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...
        초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다...초코 너무 귀엽다..."""
            .replaceAll('\n', '');

    final messageList = [message1, message2, message3];

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sheetHeight = keyboardHeight > 0
        ? screenHeight * 0.47
        : screenHeight * 0.52;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: sheetHeight + keyboardHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(
                "댓글",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF2F2F2)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 3,
                itemBuilder: (context, index) {
                  final message = messageList[index];
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 66),
                    child: CommentUserWidget(message: message),
                  );
                },
              ),
            ),

            _buildInputArea(context),

            SizedBox(height: keyboardHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/default_image.webp'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "댓글을 남겨보세요.",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFB3B3B3),
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
