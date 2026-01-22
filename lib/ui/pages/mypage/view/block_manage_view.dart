import 'package:catdog/ui/pages/mypage/view_model/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockManageView extends ConsumerWidget {
  const BlockManageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUsersAsync = ref.watch(blockViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("차단 관리"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: blockedUsersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text("차단한 사용자가 없습니다."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                title: Text(
                  user.nickname ?? '사용자',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: TextButton(
                  onPressed: () {
                    ref.read(blockViewModelProvider.notifier).unblockUser(user.id);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue, // Replaced CatdogColor.primary
                  ),
                  child: const Text("차단 해제"),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("오류가 발생했습니다: $err")),
      ),
    );
  }
}
