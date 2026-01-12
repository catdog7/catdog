import 'package:catdog/ui/pages/home/widgets/friend_home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendHomeView extends ConsumerStatefulWidget {
  final String friendUserId;
  
  const FriendHomeView({super.key, required this.friendUserId});

  @override
  ConsumerState<FriendHomeView> createState() => _FriendHomeViewState();
}

class _FriendHomeViewState extends ConsumerState<FriendHomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FriendHomeContent(friendUserId: widget.friendUserId),
    );
  }
}

