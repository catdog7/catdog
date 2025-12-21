import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FeedView extends HookConsumerWidget {
  const FeedView({
    super.key,
    required this.user,
    this.existingFeed,
  });

  final UserModel user;
  final FeedModel? existingFeed; // 수정 모드일 때 기존 피드 데이터
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(feedViewModelProvider.notifier);
    
    // 수정 모드일 때 기존 피드 데이터로 초기화
    useEffect(() {
      if (existingFeed != null) {
        Future(() {
          viewModel.initializeWithExistingFeed(
            existingFeed!,
            writerId: user.id!,
            nickname: user.nickname,
          );
        });
      }
      return null;
    }, []);

    Widget _buildPhotoArea() {
      // 뷰모델의 선택된 이미지 파일 상태를 watch
      final selectedImageFile = ref.watch(feedViewModelProvider);

      // 수정 모드이고 새 이미지를 선택하지 않았을 때 기존 이미지 URL 표시
      if (existingFeed != null && selectedImageFile == null) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              existingFeed!.imageUrl,
              fit: BoxFit.cover,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  // 이미지 피커로 사진 선택
                  await viewModel.pickImage(ImageSource.gallery);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '이미지 변경',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return selectedImageFile != null
          ? Image.file(
              selectedImageFile,
              fit: BoxFit.cover,
            )
          : Center(
              child: InkWell(
                onTap: () async {
                  // 이미지 피커로 사진 선택
                  await viewModel.pickImage(ImageSource.gallery);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 40),
                  ],
                ),
              ),
            );
    }
    
    final isEditMode = existingFeed != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '피드 수정' : '피드 작성'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                // user.id null 체크
                if (user.id == null || user.id!.isEmpty) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('모든 값을 입력해주세요.'),
                    ),
                  );
                  return;
                }

                String? errorMessage;
                try {
                  if (isEditMode && existingFeed != null) {
                    // 수정 모드
                    errorMessage = await viewModel.modifyFeed(
                      feedId: existingFeed!.id!,
                      writerId: user.id!,
                      nickname: user.nickname,
                      existingCreatedAt: existingFeed!.createdAt,
                    );
                  } else {
                    // 생성 모드
                    errorMessage = await viewModel.createFeed(
                      writerId: user.id!,
                      nickname: user.nickname,
                    );
                  }
                } catch (e) {
                  errorMessage = isEditMode
                      ? '피드 수정 중 오류가 발생했습니다: $e'
                      : '피드 등록 중 오류가 발생했습니다: $e';
                }

                if (!context.mounted) return;

                if (errorMessage == null) {
                  // 성공 시 자동 저장 취소 및 화면 닫기
                  viewModel.cancelAutoSave();
                  context.pop();
                } else {
                  // 실패 시 에러 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                    ),
                  );
                }
              },
              child: Text("완료", style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: "#태그명",
              contentPadding: EdgeInsets.only(left: 10),
            ),
            initialValue: isEditMode && existingFeed != null
                ? existingFeed!.tag.join(',')
                : null,
            onChanged: viewModel.updateTag,
          ),
          SizedBox(height: 5),
          TextFormField(
            maxLength: 200,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: "#내용을 입력하세요",
              contentPadding: EdgeInsets.only(left: 10),
            ),
            initialValue: isEditMode && existingFeed != null
                ? existingFeed!.content
                : null,
            onChanged: viewModel.updateContent,
          ),
         Expanded(
          child: _buildPhotoArea(),
         ) 
        ],
      ),
    );
  }


}
