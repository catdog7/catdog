import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/ui/pages/comments/view/widget/comment_Item.dart';
import 'package:amumal/ui/pages/comments/view/widget/comment_input_bar.dart';
import 'package:amumal/ui/pages/comments/view_model/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CommentPage extends ConsumerStatefulWidget {
  const CommentPage({
    super.key,
    required this.feedId,
    required this.user,
  });

  final String feedId;
  final UserModel user;

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      await ref
          .read(commentViewModelProvider(
            feedId: widget.feedId,
            user: widget.user,
          ).notifier)
          .createComment(content: text);

      _controller.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글 등록에 실패했습니다.')),
        );
      }
    }
  }

  Future<void> _deleteComment(String id) async {
    try {
      await ref
          .read(commentViewModelProvider(
            feedId: widget.feedId,
            user: widget.user,
          ).notifier)
          .deleteComment(id);
      
      // 성공 시 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('댓글이 삭제되었습니다.'),
          ),
        );
      }
      
    } catch (e) {
      // 에러 발생 시 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('댓글 삭제에 실패했습니다.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const pointColor = Color(0xff004aad);

    final commentState = ref.watch(
      commentViewModelProvider(
        feedId: widget.feedId,
        user: widget.user,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: pointColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "댓글 (${commentState.maybeWhen(data: (data) => data.comments.length, orElse: () => 0)})",
          style: const TextStyle(
            color: pointColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: commentState.when(
        skipError: true,
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('댓글을 불러오는 중 오류가 발생했습니다.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(commentViewModelProvider(
                      feedId: widget.feedId,
                      user: widget.user,
                    ).notifier)
                    .refresh(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (state) => Column(
          children: [
            // 댓글 리스트
            Expanded(
              child: state.comments.isEmpty
                  ? const Center(child: Text("첫 번째 댓글을 남겨보세요."))
                  : RefreshIndicator(
                      onRefresh: () => ref
                          .read(commentViewModelProvider(
                            feedId: widget.feedId,
                            user: widget.user,
                          ).notifier)
                          .refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          final c = state.comments[index];
                          final created = _dateFormat.format(c.createdAt);
                          final isMine = c.writerId == widget.user.id;

                          return CommentItem(
                            nickname: c.nickname,
                            content: c.content,
                            createdAt: created,
                            isMine: isMine,
                            onDelete: () => _deleteComment(c.id ?? ''),
                          );
                        },
                      ),
                    ),
            ),

            CommentInputBar(
              controller: _controller,
              onSend: state.isCreating
                  ? () {}
                  : () {
                      _sendComment();
                    },
            ),
          ],
        ),
      ),
    );
  }
}