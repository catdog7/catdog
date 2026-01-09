import 'dart:io';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // ✅ 이미지 피커 임포트

class FeedEditView extends HookConsumerWidget {
  final FeedDto feed;
  const FeedEditView({super.key, required this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captionController = useTextEditingController(text: feed.content);
    
    // ✅ 이미지 상태 관리 (문자열 경로 저장)
    final selectedImage = useState<String?>(feed.imageUrl);
    final isLocalFile = useState<bool>(false); // 새로 뽑은 파일인지 체크

    // ✅ 이미지 선택 함수
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImage.value = image.path;
        isLocalFile.value = true; // 로컬 파일임을 표시
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("게시글 수정", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                // ✅ 사진 선택 버튼 (이미지가 없을 때만 클릭 활성 혹은 교체용)
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xfff2f2f2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt, size: 20),
                        const SizedBox(height: 4),
                        Text(selectedImage.value != null ? "1/1" : "0/1", 
                             style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // ✅ 선택된 이미지 미리보기 (Stack)
                if (selectedImage.value != null)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            // 로컬 파일이면 FileImage, 서버 URL이면 NetworkImage 사용
                            image: isLocalFile.value 
                              ? FileImage(File(selectedImage.value!)) as ImageProvider
                              : NetworkImage(selectedImage.value!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 이미지 삭제 아이콘
                      Positioned(
                        right: -5,
                        top: -5,
                        child: GestureDetector(
                          onTap: () {
                            selectedImage.value = null;
                            isLocalFile.value = false;
                          },
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("캡션", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 176,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xfff2f2f2),
              ),
              child: TextFormField(
                controller: captionController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: "내용을 입력해주세요",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const Spacer(),
            // ✅ 하단 노란색 버튼
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: InkWell(
                onTap: () async {
                  if (selectedImage.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("사진을 선택해주세요"))
                    );
                    return;
                  }
                  
                  // ViewModel에 수정 데이터 전달 (이미지 변경 여부 포함 가능)
                  await ref.read(feedViewModelProvider.notifier)
                      .updateFeed(
                        feed.id, 
                        captionController.text, 
                        // 새로운 이미지 경로가 있다면 전달 (선택 사항)
                        newImagePath: isLocalFile.value ? selectedImage.value : null,
                      );
                  if (context.mounted) Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xffF7D358),
                  ),
                  child: const Center(
                    child: Text(
                      "수정 완료",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}