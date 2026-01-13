import 'package:catdog/ui/pages/mypage/view_model/mypage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: Text("마이페이지"),
        actions: [Icon(Icons.more_vert), SizedBox(width: 10)],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      //바디 부분 시작
      body: myPageState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // 게시글 리스트가 길어질 수 있으므로 스크롤 추가
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 104,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffFEE6A4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                myPageState.nickname ?? "이름없음",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                              "초대코드 ${myPageState.inviteCode ?? ""}",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            ],
                        ),
                         CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //  내가 쓴 게시글 리스트 (ListView 사용)
                    
                  ],
                ),
              ),
            ),
    );
  }
}
