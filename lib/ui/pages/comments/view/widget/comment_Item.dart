import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.nickname,
    required this.content,
    required this.createdAt,
    required this.isMine,
    required this.onDelete,
  });

  final String nickname;
  final String content;
  final String createdAt;
  final bool isMine;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    const pointColor = Color(0xff004aad);

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 닉네임 + 삭제 버튼 (같은 줄)
          Row(
            children: [
              Text(
                nickname,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: pointColor
                ),
              ),
              const Spacer(),

              if (isMine)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
          // 🔹 콘텐츠 + 날짜 (같은 줄)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                createdAt,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(height: 2),
        ],
      ),
    );
  }
}