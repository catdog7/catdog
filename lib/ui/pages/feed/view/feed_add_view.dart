import 'dart:io';
import 'package:catdog/ui/pages/feed/view_model/feed_add_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class FeedAddView extends HookConsumerWidget {
  const FeedAddView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captionController = useTextEditingController();
    final selectedImage = ref.watch(feedAddViewModelProvider);
    final viewModel = ref.read(feedAddViewModelProvider.notifier);
    final textLength = useState<int>(0);

    final isEnabled = selectedImage != null && textLength.value >= 1;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bool isKeyboardOpen = viewInsets.bottom > 20;
    final isPicking = useState<bool>(false); // 이미지 피커 중복 클릭 방지
    final isUploading = useState<bool>(false); // 완료버튼 중복 클릭 방지

    useEffect(() {
      FirebaseAnalytics.instance.logScreenView(
        screenName: 'Feed_Add_View',
        screenClass: 'FeedAddView',
      );
      return null;
    }, []);

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
            '새 게시글',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            if (isPicking.value) return;
                            isPicking.value = true;
                            await viewModel.pickImage();
                            FirebaseAnalytics.instance.logEvent(
                              name: 'feed_image_pick_click',
                            );
                            isPicking.value = false;
                          },
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
                            child: selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(selectedImage.path),
                                      fit: BoxFit.cover,
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
                                        selectedImage != null ? "1/1" : "0/1",
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
                                  selection: TextSelection.collapsed(
                                    offset: 100,
                                  ),
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
                    left: 20,
                    right: 20,
                    bottom: (isKeyboardOpen ? viewInsets.bottom + 10 : 20),
                  ),
                  child: GestureDetector(
                    onTap: (isEnabled && !isUploading.value)
                        ? () async {
                            // feed add view의 완료 버튼 누름
                            isUploading.value = true;
                            await FirebaseAnalytics.instance.logEvent(
                              name: 'feed_upload_start',
                            );
                            try {
                              await viewModel.uploadPost(
                                captionController.text,
                              );
                              await FirebaseAnalytics.instance.logEvent(
                                name: 'feed_upload_success', // 피드 업로드 성공 기록
                              );

                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            } catch (e) {
                              await FirebaseAnalytics.instance.logEvent(
                                name: 'feed_upload_fail', // 피드 업로드 실패 기록
                              );
                              isUploading.value = false;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
