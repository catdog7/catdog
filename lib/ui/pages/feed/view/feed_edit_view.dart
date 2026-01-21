import 'dart:io';
import 'package:catdog/data/dto/feed_dto.dart';
import 'package:catdog/ui/pages/feed/view_model/feed_view_model.dart';
import 'package:catdog/ui/pages/mypage/view_model/mypage_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FeedEditView extends HookConsumerWidget {
  final FeedDto feed;
  const FeedEditView({super.key, required this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captionController = useTextEditingController(text: feed.content);
    final selectedImage = useState<String?>(feed.imageUrl);
    final isLocalFile = useState<bool>(false);
    final textLength = useState<int>(feed.content?.length ?? 0);

    final isEnabled = selectedImage.value != null && textLength.value >= 1;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bool isKeyboardOpen = viewInsets.bottom > 20;

    final isPicking = useState<bool>(false); //이미지 피커 중복 클릭 방지
    final isUploading = useState<bool>(false); // 완료버튼 중복 클릭 방지

    useEffect(() {
      FirebaseAnalytics.instance.logScreenView(
        screenName: 'Feed_Edit_View',
        screenClass: 'FeedEditView',
      );

      FirebaseAnalytics.instance.logEvent(
        name: 'feed_edit_open',
        parameters: {
          'original_content_length': textLength.value, // 기존 글의 길이
        },
      );
      return null;
    }, []);

    Future<void> pickImage() async {
      if (isPicking.value) return;

      try {
        isPicking.value = true;
        final picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          selectedImage.value = image.path;
          isLocalFile.value = true;
        }
      } catch (e) {
        debugPrint("에러 발생: $e");
      } finally {
        isPicking.value = false;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            '게시글 수정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0x0D000000),
                              width: 1,
                            ),
                            color: const Color(0x0D000000),
                          ),
                          child: selectedImage.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: isLocalFile.value
                                      ? Image.file(
                                          File(selectedImage.value!),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          selectedImage.value!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 24,
                                                  ),
                                        ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.photo_camera_outlined,
                                      size: 24,
                                      color: Color(0xFF000000),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      selectedImage.value != null
                                          ? "1/1"
                                          : "0/1",
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0x4C000000),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        '캡션',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF121416),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 158,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0x26000000),
                            width: 1,
                          ),
                          color: const Color(0xFFFFFFFF),
                        ),
                        child: TextField(
                          controller: captionController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: '어떤 일이 있었나요?',
                            hintStyle: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0x4D000000),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF121416),
                          ),
                          onChanged: (value) {
                            textLength.value = value.length > 100
                                ? 100
                                : value.length;
                            if (value.length > 100) {
                              captionController.value = TextEditingValue(
                                text: value.substring(0, 100),
                                selection: TextSelection.collapsed(offset: 100),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${textLength.value}/100',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0x4D000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: isKeyboardOpen ? viewInsets.bottom + 10 : 20,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: (isEnabled && !isUploading.value)
                        ? () async {
                            isUploading.value = true; // 로딩 시작
                            try {
                              await ref
                                  .read(feedViewModelProvider.notifier)
                                  .updateFeed(
                                    feed.id,
                                    captionController.text,
                                    newImagePath: isLocalFile.value
                                        ? selectedImage.value
                                        : null,
                                  );
                              await FirebaseAnalytics.instance.logEvent(
                                name: 'feed_edit_success',
                                parameters: {
                                  'is_text_changed':
                                      (feed.content != captionController.text)
                                          .toString(),
                                  'final_text_length':
                                      captionController.text.length,
                                },
                              );
                              if (context.mounted) {
                                ref.read(mypageViewModelProvider.notifier).updateLocalFeed(
                                  feed.id, 
                                  captionController.text,
                                );
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              isUploading.value = false;
                              debugPrint("수정 에러: $e");
                            }
                          }
                        : null,
                    child: Container(
                      width: 335,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isEnabled
                            ? const Color(0xFFFDCA40)
                            : const Color(0x0D000000),
                      ),
                      child: Center(
                        child: Center(
                          child: isUploading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF000000),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  '완료',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isEnabled
                                        ? const Color(0xFF000000)
                                        : const Color(0x4D000000),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
