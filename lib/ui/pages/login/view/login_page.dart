import 'package:amumal/core/utils/device_id.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/ui/pages/login/view_model/login_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Loginpage extends ConsumerStatefulWidget {
  const Loginpage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends ConsumerState<Loginpage> {
  final nicknamecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool? nicknameAvailableResult;

  @override
  void dispose() {
    nicknamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(leading: SizedBox()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text("닉네임", style: TextStyle(color: Color(0xff004aad))),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "닉네임을 입력해주세요.";
                    }
                    if (nicknameAvailableResult == false) {
                      return "이미 사용 중인 닉네임입니다.";
                    }
                    return null;
                  },
                  controller: nicknamecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff004aad)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final nickname = nicknamecontroller.text;

                      // 1) 닉네임 중복 확인 (단 한 번만)
                      nicknameAvailableResult = await ref
                          .read(loginPageViewModelProvider.notifier)
                          .nicknameAvailable(nickname: nickname);

                      // 2) 중복 결과를 기반으로 validate 실행
                      if (!formkey.currentState!.validate()) {
                        return;
                      }

                      // 3) 기기 ID 생성
                      final deviceId = await getDeviceId();

                      // 4) 사용자 생성
                      final user = UserModel(
                        id: deviceId,
                        nickname: nickname,
                        createdAt: DateTime.now(),
                      );

                      // 5) 프로필 저장
                      await ref
                          .read(loginPageViewModelProvider.notifier)
                          .addProfile(user: user);

                      // 6) 저장한 최신 사용자 정보 가져오기
                      final updatedUser = await ref
                          .read(loginPageViewModelProvider.notifier)
                          .getProfile();

                      // 7) 이동
                      context.go('/home', extra: updatedUser);
                    },

                    child: Text(
                      "시작하기",
                      style: TextStyle(color: Color(0xff004aad)),
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
