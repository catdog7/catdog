import 'package:flutter/material.dart';

class DeleteDialog {
  /// 삭제 확인 팝업을 띄우고 결과를 bool로 반환합니다.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    String cancelText = "취소",
    String confirmText = "삭제",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
