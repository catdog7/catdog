import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/ui/pages/feed/view/feed_edit_view.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:catdog/ui/widgets/more_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedView extends HookConsumerWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // appBar: AppBar(),
      body: SafeArea(
        child: feedState.isLoading
            ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때
            : feedState.errorMessage != null
            ? Center(child: Text(feedState.errorMessage!)) // 에러 발생 시
            : ListView.builder(
                itemCount: feedState.feeds.length,
                itemBuilder: (context, index) {
                  final feed = feedState.feeds[index];
                  // 3. 각 피드 데이터를 카드로 전달합니다.
                  return myFeedCard(context,ref, feed, );
                },
              ),
      ),
    );
  }
}

Widget myFeedCard(BuildContext context,WidgetRef ref, FeedDto feed) {
  return Container(
    // padding: EdgeInsets.symmetric(horizontal: 20),
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              //프로필 이미지
              CircleAvatar(radius: 18, backgroundColor: Color(0xffD9D9D9)),
              SizedBox(width: 10),
              Text(
                feed.userId.length > 5
                    ? feed.userId.substring(0, 5)
                    : feed.userId,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              //수정 삭제기능 추가
              // PopupMenuButton<String>(
              //   offset: Offset(17, 62),
              //   color: Color(0xFFFFFFFF),
              //   icon: const Icon(Icons.more_vert), // 1. 아이콘
              //   onSelected: (String value) {
              //     // 2. 선택 이벤트
              //     if (value == 'edit') {
              //       print("수정 클릭");
              //     } else if (value == 'delete') {
              //       print("삭제 클릭");
              //     }
              //   },
              //   itemBuilder: (context) => [
              //     // 3. 메뉴 아이템 생성 (화살표 함수 사용)
              //     const PopupMenuItem(
              //       value: 'edit',
              //       height: 25,
              //       child: Center(child: Text('수정',style: TextStyle(fontSize: 12),)),
              //     ),
              //     const PopupMenuDivider(),
              //     const PopupMenuItem(
              //       value: 'delete',
              //       height: 25,
              //       child: Center(
              //         child: Text('삭제', style: TextStyle(fontSize: 12)),
              //       ),
              //     ),
              //   ],
              // ),
              // PopupMenuButton 자리를 MoreWidget으로 교체
              MoreWidget(
                menus: [
                  MenuAction(title: '수정', 
                  onTap: (_) {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => FeedEditView(feed: feed),));
                  
                  }),
                  MenuAction(
                    title: '삭제',
                    onTap: (_){
                      ref.read(feedViewModelProvider.notifier).deleteFeed(feed.id);
                      print("삭제 확인창 띄우기");} // 나중에 여기서 다이얼로그 호출
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 300,
          color: Color(0xffD9D9D9),
          child: Image.network(
            feed.imageUrl,
            fit: BoxFit.cover,
            // 이미지 로딩 중 실패할 경우 대비
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feed.content ?? "",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // ✅ 4. 실제 생성 날짜(createdAt) 연결
              Text(
                feed.createdAt?.toString().split(' ')[0] ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
