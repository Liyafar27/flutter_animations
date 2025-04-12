import 'dart:math';

import 'package:flutter/material.dart';

class MagicCrystal extends StatefulWidget {
  const MagicCrystal({Key? key}) : super(key: key);

  @override
  State<MagicCrystal> createState() => _MagicCrystalState();
}

class _MagicCrystalState extends State<MagicCrystal>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationController,
        _pulseController,
        _floatController,
      ]),
      builder: (context, child) {
        double pulse = 0.8 + _pulseController.value * 0.4;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              'Rotation Animations',
              style: TextStyle(
                color: Colors.lightBlue.shade300,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Colors.black,
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 150,
                    child: Transform.scale(
                      scale: pulse,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 100,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        double maxAngle = 3.1416 / 3;
                        double angle =
                            (_rotationController.value - 0.5) * 2 * maxAngle;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform:
                                      Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(angle),
                                  child: Image.asset(
                                    'assets/crystal3.png',
                                    width: 350,
                                    height: 350,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  for (int i = 0; i < 35; i++)
                    _buildFloatingParticle(i, _pulseController.value),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index, double progress) {
    final angle = (index * 72) * 3.1416 / 180;
    final radius = 80 + 10 * sin(progress * 2 * 3.1416 + index);
    final dx = radius * cos(angle);
    final dy = radius * sin(angle);

    return Positioned(
      left: 200 + dx,
      top: 250 + dy,
      child: Opacity(
        opacity: 0.5 + 0.5 * sin(progress * 2 * 3.1416 + index),
        child: Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
