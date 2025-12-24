import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/friend_dependency.dart';
import 'package:catdog/domain/model/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class FriendPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uuid = const Uuid();
    final client = ref.read(supabaseClientProvider);
    final myId = client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: TextField(), actions: [Icon(Icons.search)]),
      body: Center(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                //await ref.read(friendRepositoryProvider).addFriend(FriendModel(id: uuid.v4(), userAId: myId!, userBId: userBId));
              },
            ),
          ],
        ),
      ),
    );
  }
}
