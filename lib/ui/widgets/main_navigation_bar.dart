import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onWritePressed;
  final bool isDisabled;

  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onWritePressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 네비게이션바 위 구분선
        Container(
          height: 1,
          color: Colors.black.withOpacity(0.15),
        ),
        Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 네비게이션 아이템 영역
              Container(
                padding: EdgeInsets.only(
                  top: 4,
                  bottom: MediaQuery.of(context).padding.bottom, // 아이폰 safe area 하단 패딩
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    // left border 제거 (하단 바와 겹치지 않도록)
                    top: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.15),
                    ),
                    right: BorderSide(
                      color: Colors.black.withOpacity(0.15),
                    ),
                    // bottom border 제거 (하단 바와 겹치지 않도록)
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                        child: _NavItem(
                          icon: Icons.home,
                          label: '홈',
                          isActive: selectedIndex == 0,
                          onTap: () => onItemSelected(0),
                          isDisabled: isDisabled,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 52,
                        child: _NavItem(
                          icon: Icons.sticky_note_2,
                          label: '게시글',
                          isActive: selectedIndex == 1,
                          onTap: () => onItemSelected(1),
                          isDisabled: isDisabled,
                        ),
                      ),
                    ),
                    // FAB 공간 (게시글과 친구 사이) - 버튼이 여기에 위치
                    GestureDetector(
                      onTap: onWritePressed,
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF121416),
                            shape: CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 52,
                        child: _NavItem(
                          icon: Icons.group,
                          label: '친구',
                          isActive: selectedIndex == 2,
                          onTap: () => onItemSelected(2),
                          isDisabled: isDisabled,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 52,
                        child: _NavItem(
                          icon: Icons.account_circle,
                          label: '내정보',
                          isActive: selectedIndex == 3,
                          onTap: () => onItemSelected(3),
                          isDisabled: isDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDisabled;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabledColor = const Color(0xFF8C8C8C);
    final activeColor = const Color(0xFFFCBC0D);
    final inactiveColor = Colors.grey;
    final iconColor = isDisabled ? disabledColor : (isActive ? activeColor : inactiveColor);
    final textColor = isDisabled ? disabledColor : (isActive ? activeColor : inactiveColor);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: iconColor,
            fill: isActive ? 1.0 : 0.0, // 활성일 때 채워진 아이콘
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
