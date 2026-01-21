import 'package:flutter/material.dart';

class MagicWandLoader extends StatefulWidget {
  const MagicWandLoader({super.key});

  @override
  State<MagicWandLoader> createState() => _MagicWandLoaderState();
}

class _MagicWandLoaderState extends State<MagicWandLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Align(
                  alignment: const Alignment(0, -0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildPulse(0.0),
                              _buildPulse(0.3),
                              _buildPulse(0.6),
                              Image.asset(
                                'assets/images/magic_wand.webp',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "AI 프로필 봇이 필터링 중이에요.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "댕냥이 사진 외의 다른 사진으로\n프로필을 설정할 수 없어요.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPulse(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        double prog = (_controller.value + delay) % 1.0;
        return Container(
          width: 80 + (prog * 180),
          height: 80 + (prog * 180),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFEEBB8).withOpacity((1.0 - prog) * 0.8),
          ),
        );
      },
    );
  }
}
