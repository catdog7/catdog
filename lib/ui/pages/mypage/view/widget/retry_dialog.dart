import 'package:flutter/material.dart';

class RetryDialog {
  /// 삭제 확인 팝업을 띄우고 결과를 bool로 반환합니다.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    String cancelText = "닫기",
    String confirmText = "프로필 설정하기",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9), // 사진 속 연한 회색 배경
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.priority_high, // 느낌표 아이콘
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // 취소 버튼
                    Expanded(
                      child: _buildButton(
                        text: cancelText,
                        onTap: () => Navigator.pop(context, false),
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildButton(
                        text: confirmText,
                        onTap: () => Navigator.pop(context, true),
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false; // null 체크
  }

  static Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF121416) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isPrimary ? Colors.white : const Color(0xFFD9D9D9),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : const Color(0xFF666666),
            fontSize: 16,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
