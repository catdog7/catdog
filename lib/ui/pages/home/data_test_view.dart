import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class DataTestView extends ConsumerStatefulWidget {
  const DataTestView({super.key});

  @override
  ConsumerState<DataTestView> createState() => _DataTestViewState();
}

class _DataTestViewState extends ConsumerState<DataTestView> {
  late final SupabaseClient client;
  final uuid = const Uuid();
  String status = 'Ready to test data';
  
  final _targetIdController = TextEditingController();
  final _feedIdController = TextEditingController();
  String? lastFeedId;

  @override
  void initState() {
    super.initState();
    client = ref.read(supabaseClientProvider);
  }

  @override
  void dispose() {
    _targetIdController.dispose();
    _feedIdController.dispose();
    super.dispose();
  }

  void updateStatus(String msg) {
    setState(() {
      status = msg;
    });
    print(msg);
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
      _feedIdController.text = id;
      updateStatus('Feed Created by $myId: $id');
    } catch (e) {
      updateStatus('Feed Error: $e');
    }
  }

  Future<void> testFeedLike() async {
    final myId = client.auth.currentUser?.id;
    final feedId = _feedIdController.text.trim();
    
    if (myId == null) return updateStatus('Login first!');
    if (feedId.isEmpty) return updateStatus('Enter Feed ID first!');
    
    try {
      await client.from('feed_likes').insert({
        'feed_id': feedId,
        'user_id': myId,
      });
      updateStatus('Feed Like Created by $myId for Feed $feedId');
    } catch (e) {
      updateStatus('Feed Like Error: $e');
    }
  }

  Future<void> testComment() async {
    final myId = client.auth.currentUser?.id;
    final feedId = _feedIdController.text.trim();

    if (myId == null) return updateStatus('Login first!');
    if (feedId.isEmpty) return updateStatus('Enter Feed ID first!');

    try {
      await client.from('comments').insert({
        'feed_id': feedId,
        'user_id': myId,
        'content': 'RLS is working!',
      });
      updateStatus('Comment Created by $myId for Feed $feedId');
    } catch (e) {
      updateStatus('Comment Error: $e');
    }
  }

  Future<void> testFollowRequest() async {
    final myId = client.auth.currentUser?.id;
    final targetUserId = _targetIdController.text.trim();
    if (myId == null) return updateStatus('Login first!');
    if (targetUserId.isEmpty) return updateStatus('Enter Target User ID!');
    
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
    final targetUserId = _targetIdController.text.trim();
    if (myId == null) return updateStatus('Login first!');
    if (targetUserId.isEmpty) return updateStatus('Enter Target User ID!');

    try {
      final userA = myId.compareTo(targetUserId) < 0 ? myId : targetUserId;
      final userB = myId.compareTo(targetUserId) < 0 ? targetUserId : myId;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Data Test')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Status: $status', style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildTestButton(Icons.pets, 'Create Pet', Colors.orange, testPet),
                  const SizedBox(height: 8),
                  _buildTestButton(Icons.feed, 'Create Feed', Colors.green, testFeed),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _feedIdController,
                    decoration: const InputDecoration(labelText: 'Feed ID', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildTestButton(Icons.thumb_up, 'Like Feed', Colors.blue, testFeedLike)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTestButton(Icons.comment, 'Comment', Colors.purple, testComment)),
                    ],
                  ),
                  const Divider(height: 32),
                  TextField(
                    controller: _targetIdController,
                    decoration: const InputDecoration(labelText: 'Target User ID', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTestButton(Icons.person_add, 'Follow', Colors.pink, testFollowRequest)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTestButton(Icons.group_add, 'Friend', Colors.indigo, testFriend)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTestButton(Icons.notifications, 'Save FCM Token', Colors.teal, testFcmToken),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await client.auth.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(IconData icon, String title, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 44),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
