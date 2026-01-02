import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedView extends HookConsumerWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // appBar: AppBar(),
      body: SafeArea(
        child:ListView.builder(
             itemCount: 10,
             itemBuilder: (context, index) {
               return MyFeedCard();
             },
        ),
      ),
    );
  }
}

 Widget MyFeedCard(){
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
              Text("닉네임",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              ),
              Spacer(),
              GestureDetector(
               onTap: () {
                print("수정 삭제 메뉴 열기");
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
          child: Icon(Icons.image,color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   Icon(Icons.favorite_border, size: 24),
                   SizedBox(width: 5),
                   Text("45"),
                   SizedBox(width: 15),
                   Icon(Icons.chat_bubble_outline, size: 24),
                   SizedBox(width: 5),
                   Text("2"),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "고양이가 어떻게 세모네모",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,// 글이 넘치면 처리해주는 코드
              ),
              const SizedBox(height: 4),
              Text(
                "2025년 12월 5일",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        )
      ],
    ),
  );
 }
 