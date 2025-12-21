import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TestSupabasePage extends StatefulWidget {
  const TestSupabasePage({super.key});

  @override
  State<TestSupabasePage> createState() => _TestSupabasePageState();
}

class _TestSupabasePageState extends State<TestSupabasePage> {
  final client = Supabase.instance.client;
  final uuid = const Uuid();
  String status = 'Ready to test';

  // Test Data IDs
  String? lastUserId;
  String? targetUserId; // 팔로우 대상이 될 유저 ID
  String? lastFeedId;

  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    lastUserId = client.auth.currentUser?.id;
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          lastUserId = data.session?.user.id;
          if (lastUserId != null) {
            status = 'Logged in as ${data.session?.user.email}';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void updateStatus(String msg) {
    setState(() {
      status = msg;
    });
    print(msg);
  }

  Future<void> testUser() async {
    try {
      if (lastUserId != null) {
        targetUserId = lastUserId;
      }

      final randomStr = uuid.v4().substring(0, 8);
      final email = 'catdog_$randomStr@gmail.com';
      final password = 'password123';
      
      updateStatus('Attempting SignUp: $email');
      
      final res = await client.auth.signUp(
        email: email,
        password: password,
        data: {'nickname': 'Tester_$randomStr'},
      );
      
      if (res.user != null) {
        lastUserId = res.user!.id;
        updateStatus('Success! Auth User Created: $lastUserId\nEmail: $email');
      }
    } catch (e) {
      updateStatus('Auth Error Detail: $e');
    }
  }

  Future<void> testGoogleLogin() async {
    try {
      updateStatus('Starting Google Login (OAuth)...');
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.catdog://login-callback/',
      );
    } catch (e) {
      updateStatus('Google Login Error: $e');
    }
  }

  Future<void> testSignOut() async {
    await client.auth.signOut();
    setState(() {
      lastUserId = null;
      targetUserId = null;
      status = 'Signed Out. Create a new user to start.';
    });
  }

  Future<void> testPet() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null) return updateStatus('Login first!');
    try {
      await client.from('pets').insert({
        'user_id': myId,
        'name': 'Happy',
        'species': 'DOG',
        'birth_date_precision': 'EXACT',
      });
      updateStatus('Pet Created for current user: $myId');
    } catch (e) {
      updateStatus('Pet Error: $e');
    }
  }

  Future<void> testFeed() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null) return updateStatus('Login first!');
    try {
      final id = uuid.v4();
      await client.from('feeds').insert({
        'id': id,
        'user_id': myId,
        'image_url': 'https://example.com/image.jpg',
        'content': 'Hello RLS World!',
      });
      lastFeedId = id;
      updateStatus('Feed Created by $myId: $id');
    } catch (e) {
      updateStatus('Feed Error: $e');
    }
  }

  Future<void> testFeedLike() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null || lastFeedId == null) return updateStatus('Login and Create Feed first!');
    try {
      await client.from('feed_likes').insert({
        'feed_id': lastFeedId,
        'user_id': myId,
      });
      updateStatus('Feed Like Created by $myId');
    } catch (e) {
      updateStatus('Feed Like Error: $e');
    }
  }

  Future<void> testComment() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null || lastFeedId == null) return updateStatus('Login and Create Feed first!');
    try {
      await client.from('comments').insert({
        'feed_id': lastFeedId,
        'user_id': myId,
        'content': 'RLS is working!',
      });
      updateStatus('Comment Created by $myId');
    } catch (e) {
      updateStatus('Comment Error: $e');
    }
  }

  Future<void> testFollowRequest() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null) return updateStatus('Login first!');
    if (targetUserId == null) return updateStatus('Create at least TWO users to test follow!');
    
    try {
      await client.from('follow_requests').insert({
        'from_user_id': myId,
        'to_user_id': targetUserId,
        'status': 'PENDING',
        'type': 'FRIEND',
      });
      updateStatus('Follow Request Sent from $myId to $targetUserId');
    } catch (e) {
      updateStatus('Follow Error: $e');
    }
  }

  Future<void> testFriend() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null) return updateStatus('Login first!');
    if (targetUserId == null) return updateStatus('Create at least TWO users to test friend!');

    try {
      final userA = myId.compareTo(targetUserId!) < 0 ? myId : targetUserId!;
      final userB = myId.compareTo(targetUserId!) < 0 ? targetUserId! : myId;

      await client.from('friends').insert({
        'user_a_id': userA,
        'user_b_id': userB,
      });
      updateStatus('Friendship Created between $userA and $userB');
    } catch (e) {
      updateStatus('Friend Error: $e');
    }
  }

  Future<void> testFcmToken() async {
    final myId = client.auth.currentUser?.id;
    if (myId == null) return updateStatus('Login first!');
    try {
      await client.from('fcm_tokens').insert({
        'user_id': myId,
        'token': 'token_${uuid.v4().substring(0, 8)}',
        'platform': 'ANDROID',
      });
      updateStatus('FCM Token Saved for $myId');
    } catch (e) {
      updateStatus('FCM Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAuthId = client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Supabase 8 Tables Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Auth ID: ${currentAuthId ?? "None (Login first)"}', 
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Target User ID: ${targetUserId ?? "None (Need 2nd user)"}', 
                    style: const TextStyle(fontSize: 12, color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text('Status: $status', style: const TextStyle(fontSize: 13)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: testUser, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[100]),
              child: const Text('1. 유저 생성 (연속 2번 클릭 시 팔로우 테스트 가능)')
            ),
            ElevatedButton(
              onPressed: testGoogleLogin, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
              child: const Text('구글 로그인 테스트 (OAuth)')
            ),
            ElevatedButton(onPressed: testSignOut, child: const Text('로그아웃 (초기화)')),
            const Divider(height: 30),
            ElevatedButton(onPressed: testPet, child: const Text('2. 펫 생성 (pets)')),
            ElevatedButton(onPressed: testFeed, child: const Text('3. 피드 생성 (feeds)')),
            ElevatedButton(onPressed: testFeedLike, child: const Text('4. 피드 좋아요 (feed_likes)')),
            ElevatedButton(onPressed: testComment, child: const Text('5. 댓글 생성 (comments)')),
            ElevatedButton(
              onPressed: testFollowRequest, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[50]),
              child: const Text('6. 팔로우 요청 (Target ID 필요)')
            ),
            ElevatedButton(
              onPressed: testFriend, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[50]),
              child: const Text('7. 친구 생성 (Target ID 필요)')
            ),
            ElevatedButton(onPressed: testFcmToken, child: const Text('8. FCM 토큰 생성 (fcm_tokens)')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
