import 'dart:io';
import 'package:catdog/ui/pages/feed/view_model/feed_add_view_model.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class FeedAddView extends HookConsumerWidget {
  const FeedAddView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //캡션 관리해주는 컨트롤러
    final captionController = useTextEditingController();
    //생성된 provider을 watch로 지켜봄
    final selectedImage = ref.watch(feedAddViewModelProvider);
    //기능을 호출하기 위한 notifier
    final viewModel = ref.read(feedAddViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("새 게시글", style: TextStyle(fontSize: 16)),
        actions: [
          Container(alignment: Alignment.center),
          // 닫기 버튼
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
      //바디 시작
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: double.infinity),
            //이미지 피커 시작부분
            InkWell(
              onTap: () {
                viewModel.pickImage();
              },
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xfff2f2f2),
                  // 사진이 선택되었다면 null 아니면 배경이미지
                  image: selectedImage != null
                      ? DecorationImage(
                          image: FileImage(File(selectedImage.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selectedImage == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 20),
                          SizedBox(height: 4),
                          Text("0/1"),
                        ],
                      )
                    : null,
              ),
            ),
            SizedBox(height: 30),

            //캡션 시작 부분
            Text("캡션"),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 176,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xfff2f2f2),
              ),
              child: TextFormField(
                controller: captionController,
                maxLength: 500,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "어떤일이 있었나요?",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: InputBorder.none,
                  counterText: "",
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            Spacer(),
            //완료 버튼
            InkWell(
              onTap: () async {
                if (selectedImage == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("사진을 선택해주세요")));
                  return;
                }
                // 사용자가 입력한 글자(captionController.text)를 넘겨줍니다.
                await viewModel.uploadPost(captionController.text);

                // 3. 완료 후 화면 닫기 (선택 사항)
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Ink(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xfff2f2f2),
                ),
                child: Center(
                  child: Text(
                    "완료",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
