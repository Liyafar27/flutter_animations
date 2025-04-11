import 'dart:math';

import 'package:flutter/material.dart';

class CarDrivePage extends StatefulWidget {
  @override
  _CarDrivePageState createState() => _CarDrivePageState();
}

class _CarDrivePageState extends State<CarDrivePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _carPosition;
  late Animation<double> _wheelRotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _carPosition = Tween<double>(
      begin: -300,
      end: 400,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _wheelRotation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWheel({required double offsetX, required double offsetY}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Positioned(
          left: offsetX,
          top: offsetY,
          child: Transform.rotate(angle: _wheelRotation.value, child: child),
        );
      },
      child: Image.asset('assets/wheel.png', height: 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Car Animations',
          style: TextStyle(
            color: Colors.purpleAccent.shade200,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Transform.translate(
            offset: Offset(_carPosition.value, 100),
            child: Stack(
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Image.asset('assets/car.png', height: 120),
                ),
                _buildWheel(offsetX: 0, offsetY: 52),
                _buildWheel(offsetX: 180, offsetY: 52),
              ],
            ),
          );
        },
      ),
    );
  }
}
