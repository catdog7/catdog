import 'package:catdog/ui/pages/feed/view/feed_view.dart';
import 'package:catdog/ui/pages/mypage/view_model/mypage_view_model.dart';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MypageView extends HookConsumerWidget {
  const MypageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPageState = ref.watch(mypageViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text("마이페이지", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          Icon(Icons.more_vert),
          SizedBox(width: 15),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // 스크롤 시 앱바 색상 변함 방지
      ),
      body: myPageState.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  상단 프로필 카드 (노란색 영역)
                  _buildProfileHeader(myPageState),
                  
                  const SizedBox(height: 30),
                  
                  //  내가 쓴 게시글 목록 
                  if (myPageState.myFeeds.isEmpty)
                    const Center(child: Text("\n아직 작성한 게시글이 없습니다."))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myPageState.myFeeds.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final feed = myPageState.myFeeds[index];
                        // ✅ 새로 바뀐 피드 카드 위젯 호출
                        return myFeedCard(context, ref, feed);
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }

  // 상단 노란색 프로필 카드 위젯
  Widget _buildProfileHeader(dynamic state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffFEE6A4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.nickname ?? "이름 없음", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "초대코드 ${state.inviteCode ?? ""}",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            backgroundImage: state.profileImageUrl != null 
                ? NetworkImage(state.profileImageUrl!) 
                : null,
            child: state.profileImageUrl == null 
                ? const Icon(Icons.person, size: 40, color: Colors.grey) 
                : null,
          ),
        ],
      ),
    );
  }
}