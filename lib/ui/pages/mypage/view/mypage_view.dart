import 'package:catdog/ui/pages/feed/view/feed_view.dart';
import 'package:catdog/ui/pages/mypage/view/mypage_edit_view.dart';
import 'package:catdog/ui/pages/mypage/view_model/mypage_view_model.dart';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        scrolledUnderElevation: 0,
      ),
      body: myPageState.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildProfileHeader(context, myPageState),
                  
                  const SizedBox(height: 30),
                  
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
                        return myFeedCard(context, ref, feed);
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }


  Widget _buildProfileHeader(BuildContext context, dynamic state) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.nickname ?? "이름 없음", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // 코드 복사
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (state.inviteCode != null) {
                        Clipboard.setData(ClipboardData(text: state.inviteCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("초대코드를 클립보드에 복사했습니다.")),
                        );
                      }
                    },
                    child: const Icon(Icons.copy, size: 16, color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "초대코드 ${state.inviteCode ?? ""}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          // 이미지 편집 함수를 호출합니다.
          _buildProfileImageStack(context, state),
        ],
      ),
    );
  }

  //stack 함수입니다.
  Widget _buildProfileImageStack(BuildContext context, dynamic state) {
    return Stack(
      children: [
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
        // 연필 모양 편집 버튼
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> MypageEditView()));
              
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}