import 'package:flutter/material.dart';

class NeonGlowAnimation extends StatefulWidget {
  const NeonGlowAnimation({super.key});

  @override
  State<NeonGlowAnimation> createState() => _NeonGlowAnimationState();
}

class _NeonGlowAnimationState extends State<NeonGlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // пульсация туда-обратно

    _glowAnimation = Tween<double>(begin: 10, end:  30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.8),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/image_hero2.png',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
