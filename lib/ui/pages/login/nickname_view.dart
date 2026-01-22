import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/user_dependency.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NicknameView extends ConsumerStatefulWidget {
  const NicknameView({super.key});

  @override
  ConsumerState<NicknameView> createState() => _NicknameViewState();
}

class _NicknameViewState extends ConsumerState<NicknameView> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  bool get isValidNickname {
    final length = _controller.text.trim().length;
    return length >= 3 && length <= 10;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNickname() async {
    if (!isValidNickname) return;

    setState(() => _isLoading = true);

    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final userInput = _controller.text.trim();
      final useCase = ref.read(userUseCaseProvider);

      // 중복되지 않는 닉네임 생성 (사용자 입력 + "-" + 5자리 랜덤 문자열)
      final finalNickname = await useCase.generateUniqueNickname(userInput);

      // 생성된 닉네임으로 업데이트
      await useCase.updateNickname(userId, finalNickname);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeView(initialIndex: 0)),
          (route) => false,
        );
      }
    } catch (e) {
      print('Nickname Save Error: $e');
      if (mounted) {
        String errorMessage = '에러가 발생했습니다.';
        if (e is ArgumentError) {
          errorMessage = e.message ?? '닉네임 형식이 올바르지 않습니다.';
        } else {
          errorMessage = e.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _controller.text.trim();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // 반응형 크기 계산
    final horizontalPadding = screenWidth * 0.053; // 20/375 ≈ 0.053
    final topPadding = screenHeight * 0.074; // 60/812 ≈ 0.074
    final titleSpacing = screenHeight * 0.049; // 40/812 ≈ 0.049
    final titleFontSize = screenWidth * 0.064; // 24/375 ≈ 0.064
    final labelSpacing = screenHeight * 0.01; // 8/812 ≈ 0.01
    final inputSpacing = screenHeight * 0.007; // 6/812 ≈ 0.007
    final bottomSpacing = screenHeight * 0.049; // 40/812 ≈ 0.049

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 레이아웃 변경 방지
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: topPadding),

                      // 타이틀
                      Text(
                        '사용할 닉네임을\n입력해주세요.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: titleFontSize,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                          letterSpacing: -0.65,
                        ),
                      ),

                      SizedBox(height: titleSpacing),

                      // 라벨
                      Text(
                        '닉네임',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035, // 13/375 ≈ 0.035
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: labelSpacing),

                      // 입력창
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.043, // 16/375 ≈ 0.043
                          vertical: screenHeight * 0.015, // 12/812 ≈ 0.015
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: nickname.isEmpty
                                ? Colors.black.withOpacity(0.15)
                                : isValidNickname
                                    ? const Color(0xFF0059EA)
                                    : const Color(0xFFFE3752),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLength: 10,
                          enabled: !_isLoading,
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: '닉네임을 설정해주세요.',
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      SizedBox(height: inputSpacing),

                      // 상태 텍스트
                      if (nickname.isNotEmpty)
                        Text(
                          isValidNickname
                              ? '사용가능한 닉네임입니다.'
                              : '닉네임은 3글자 이상 10글자 이하로 입력해주세요.',
                          style: TextStyle(
                            color: isValidNickname
                                ? Colors.black
                                : const Color(0xFFFE3752),
                            fontSize: screenWidth * 0.035, // 13/375 ≈ 0.035
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      SizedBox(height: bottomSpacing),
                    ],
                  ),
                ),
              ),
            ),

            // 완료 버튼 (화면 맨 아래 고정)
            Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: keyboardHeight > 0 
                    ? keyboardHeight + screenHeight * 0.025 
                    : screenHeight * 0.025,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 다른 아이디로 로그인 버튼
                  Center(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              try {
                                final client = ref.read(supabaseClientProvider);
                                final session = client.auth.currentSession;
                                
                                if (session != null) {
                                  final userId = session.user.id;
                                  print('Deleting user: $userId');
                                  
                                  // 1. users 테이블에서 해당 아이디로 저장된 로우 삭제
                                  try {
                                    // 삭제 전 확인
                                    final beforeDelete = await client
                                        .from('users')
                                        .select('id')
                                        .eq('id', userId)
                                        .maybeSingle();
                                    print('Before delete - User exists: ${beforeDelete != null}');
                                    
                                    // 삭제 실행
                                    final deleteResult = await client
                                        .from('users')
                                        .delete()
                                        .eq('id', userId);
                                    
                                    print('Delete query executed. Result: $deleteResult');
                                    
                                    // 삭제 후 확인
                                    final afterDelete = await client
                                        .from('users')
                                        .select('id')
                                        .eq('id', userId)
                                        .maybeSingle();
                                    
                                    if (afterDelete == null) {
                                      print('✅ User successfully deleted from users table');
                                    } else {
                                      print('❌ WARNING: User still exists in users table (RLS policy may be blocking DELETE)');
                                    }
                                  } catch (deleteError) {
                                    print('❌ Delete from users table error: $deleteError');
                                    print('This is likely due to missing RLS DELETE policy');
                                  }
                                  
                                  // 2. Supabase authentication에서도 세션 제거
                                  // 주의: signOut()은 세션만 제거하고 auth.users에서 사용자를 삭제하지는 않습니다.
                                  // auth.users에서 실제로 삭제하려면 서버 사이드 Edge Function이나 Admin API가 필요합니다.
                                  // 하지만 signOut() 후 다시 로그인하면 새로운 사용자로 생성되므로 문제없습니다.
                                  await client.auth.signOut();
                                  print('Signed out successfully');
                                  print('Note: auth.users record still exists, but session is cleared. User will be recreated on next login.');
                                } else {
                                  print('No session found');
                                }
                              } catch (e) {
                                print('Delete user and logout error: $e');
                                print('Error details: ${e.toString()}');
                                // 에러가 나도 로그아웃은 시도
                                try {
                                  await ref.read(supabaseClientProvider).auth.signOut();
                                  print('SignOut completed despite error');
                                } catch (signOutError) {
                                  print('SignOut error: $signOutError');
                                }
                              }
                              
                              // 로그인 화면으로 이동
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '다른 아이디로 로그인',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.032, // 12/375 ≈ 0.032
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01), // 8/812 ≈ 0.01
                  // 완료 버튼
                  GestureDetector(
                    onTap: isValidNickname && !_isLoading ? _saveNickname : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017), // 14/812 ≈ 0.017
                      decoration: BoxDecoration(
                        color: isValidNickname
                            ? const Color(0xFFFDCA40)
                            : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: screenWidth * 0.053, // 20/375 ≈ 0.053
                                height: screenWidth * 0.053,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : Text(
                                '완료',
                                style: TextStyle(
                                  color: isValidNickname
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.3),
                                  fontSize: screenWidth * 0.043, // 16/375 ≈ 0.043
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
