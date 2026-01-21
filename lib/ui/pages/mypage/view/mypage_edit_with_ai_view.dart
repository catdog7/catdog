import 'package:catdog/ui/pages/mypage/view/widget/magic_wand_loader.dart';
import 'package:catdog/ui/pages/mypage/view/widget/retry_dialog.dart';
import 'package:catdog/ui/pages/mypage/view_model/mypage_view_model.dart';
import 'package:catdog/ui/pages/mypage/view_model/pet_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MypageEditWithAiView extends HookConsumerWidget {
  const MypageEditWithAiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state1 = ref.watch(mypageViewModelProvider);

    final nicknameController = useTextEditingController(text: state1.nickname);
    final isPicking = useState(false);

    //  GEMINI 버전
    final state2 = ref.watch(petAnalysisProvider);
    Future<void> handlePickProcess() async {
      if (isPicking.value) return;

      isPicking.value = true;

      try {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery);

        if (image == null) {
          isPicking.value = false;
          return;
        }

        await ref.read(petAnalysisProvider.notifier).startAnalysis(image);
        final isPet = ref.read(petAnalysisProvider).value;

        if (isPet == true) {
          await ref
              .read(mypageViewModelProvider.notifier)
              .updateProfileImage(image.path);
          isPicking.value = false;
        } else {
          final wantRetry = await RetryDialog.show(
            context: context,
            title: "댕냥이 사진으로 다시 설정해주세요.",
          );

          if (wantRetry == true) {
            isPicking.value = false;
            await handlePickProcess();
          } else {
            // 닫기를 누른 경우
            isPicking.value = false;
          }
        }
      } catch (e) {
        isPicking.value = false;
      }
    }

    return state2.when(
      skipError: true,
      error: (error, _) => Scaffold(body: Center(child: Text("에러: $error"))),
      loading: () => const MagicWandLoader(),
      data: (isPetResult) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context), // 코드가 길어지므로 AppBar 분리 권장
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    // 화면 최소 높이를 확보하여 내용이 적어도 꽉 차 보이게 함
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // 위아래 분산 배치
                        children: [
                          // --- 상단 콘텐츠 영역 ---
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              // 프로필 사진 수정
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: const Color(0xFFF8FAFE),
                                      backgroundImage:
                                          state1.profileImageUrl != null
                                          ? NetworkImage(
                                              state1.profileImageUrl!,
                                            )
                                          : null,
                                      child: state1.profileImageUrl == null
                                          ? const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: !isPicking.value
                                            ? () => handlePickProcess()
                                            : null,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                "닉네임",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildNicknameTextField(nicknameController),
                            ],
                          ),

                          // --- 하단 안내문 및 완료 버튼 영역 ---
                          Column(
                            children: [
                              const SizedBox(height: 40), // 콘텐츠와 하단 사이 최소 간격
                              _buildAiInfoBanner(),
                              const SizedBox(height: 20),
                              //  완료 버튼
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await ref
                                        .read(mypageViewModelProvider.notifier)
                                        .updateNickname(
                                          nicknameController.text,
                                        );

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFFFDCA40,
                                    ), // 기획안 노란색
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text(
                                    "완료",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAiInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        border: Border.all(color: const Color(0xFFEBEDF1)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/star.webp', width: 18, height: 18),
              const SizedBox(width: 8),
              const Text(
                "AI 프로필 봇",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "댕냥이 사진으로 프로필을 설정해보세요!\n댕냥이 사진 외의 사진은 AI 프로필 봇이 필터링 해줘요.",
            style: TextStyle(
              color: Color(0xFF636466),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 2. 닉네임 입력 필드
  Widget _buildNicknameTextField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // 숫자를 오른쪽으로 정렬
      children: [
        TextField(
          controller: controller,
          maxLength: 10,
          decoration: InputDecoration(
            // 1. 기본 카운터는 숨깁니다 (간격 조절이 안 되기 때문)
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
              ), // enabledBorder와 동일하게 설정
            ),
          ),
        ),
        // 2. 상자 바로 아래에 배치할 숫자 (사진처럼 바짝 붙임)
        const SizedBox(height: 4), // 이 숫자를 조절해서 상자와의 간격을 맞추세요
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return Text(
              '${value.text.length}/10',
              style: const TextStyle(
                color: Color(0xFFB3B3B3), // 연한 회색
                fontSize: 13,
              ),
            );
          },
        ),
      ],
    );
  }

  // 5. AppBar 분리
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "프로필 수정",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
