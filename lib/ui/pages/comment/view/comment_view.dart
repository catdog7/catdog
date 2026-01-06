import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//수정중
class CommentView extends ConsumerWidget {
  CommentView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comment = useTextEditingController();

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double sheetHeight = MediaQuery.of(context).size.height * 0.5;

    return Container(
      height: sheetHeight + keyboardHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "댓글",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 2,
              itemBuilder: (context, index) => _buildCommentTile(),
            ),
          ),

          _buildInputArea(context),

          SizedBox(height: keyboardHeight),
        ],
      ),
    );
  }

  Widget _buildCommentTile() {
    return ListTile(
      leading: const CircleAvatar(backgroundImage: NetworkImage('유저 프로필 이미지')),
      title: Row(
        children: [
          const Text(
            "아이디",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text("12월 5일", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      subtitle: const Text("초코 너무 귀엽다..."),
      trailing: const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('내 프로필'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "댓글을 남겨보세요.",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14),
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
