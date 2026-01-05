import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
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
        child:feedState.isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때
          : feedState.errorMessage != null
              ? Center(child: Text(feedState.errorMessage!)) // 에러 발생 시
              : ListView.builder(
                  itemCount: feedState.feeds.length,
                  itemBuilder: (context, index) {
                    final feed = feedState.feeds[index];
                    // 3. 각 피드 데이터를 카드로 전달합니다.
                    return myFeedCard(feed); 
                  },
                ),
          
        
      ),
    );
  }
}

 Widget myFeedCard(FeedDto feed){
  return Container(
    // padding: EdgeInsets.symmetric(horizontal: 20),
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              //프로필 이미지 
              CircleAvatar(radius: 18,backgroundColor: Color(0xffD9D9D9)),
              SizedBox(width: 10),
              Text(feed.userId.length > 5 ? feed.userId.substring(0, 5) : feed.userId,style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              ),
              Spacer(),
              GestureDetector(
               onTap: () {
                
               },
                 child: Icon(Icons.more_vert),
              )
              
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
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                   Text(
                feed.content ?? "",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
        )
      ],
    ),
  );
 }
 