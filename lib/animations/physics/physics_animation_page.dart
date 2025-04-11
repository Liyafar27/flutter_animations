import 'package:flutter/material.dart';

class PhysicsAnimationPage extends StatefulWidget {
  @override
  _PhysicsAnimationPageState createState() => _PhysicsAnimationPageState();
}

class _PhysicsAnimationPageState extends State<PhysicsAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late Animation<double> _bounceAnimation;
  late Animation<double> _bounceAnimation2;
  late Animation<double> _bounceAnimation3;
  late Animation<double> _bounceAnimation4;

  final double _ballRadius = 60; // Радиус мяча

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    _controller3 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _controller4 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 500,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _bounceAnimation2 = Tween<double>(
      begin: 100,
      end: 500,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.bounceOut));
    _bounceAnimation3 = Tween<double>(
      begin: 200,
      end: 500,
    ).animate(CurvedAnimation(parent: _controller3, curve: Curves.bounceOut));
    _bounceAnimation4 = Tween<double>(
      begin: 300,
      end: 500,
    ).animate(CurvedAnimation(parent: _controller4, curve: Curves.bounceOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Physics-Based Animation' ,style: TextStyle(
        color: Colors.purpleAccent,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),)),
      body: Align(alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              Row(
                children: [
                  BouncingBallWidget(
                    animation: _bounceAnimation2,
                    imagePath: 'assets/ball5.png',
                    width: _ballRadius,
                    height: _ballRadius,
                  ),
                  BouncingBallWidget(
                    animation: _bounceAnimation4,
                    imagePath: 'assets/ball1.png',
                    width: _ballRadius* 0.9,
                    height: _ballRadius,
                  ),
                  BouncingBallWidget(
                    animation: _bounceAnimation,
                    imagePath: 'assets/ball2.png',
                    width: _ballRadius * 0.5,
                    height: _ballRadius * 0.5,
                  ),
                  BouncingBallWidget(
                    animation: _bounceAnimation2,
                    imagePath: 'assets/ball3.png',
                    width: _ballRadius * 2,
                    height: _ballRadius * 2,
                  ),
                  BouncingBallWidget(
                    animation: _bounceAnimation4,
                    imagePath: 'assets/ball4.png',
                    width: _ballRadius * 0.9,
                    height: _ballRadius,
                  ),
                  BouncingBallWidget(
                    animation: _bounceAnimation3,
                    imagePath: 'assets/ball.png',
                    width: _ballRadius * 0.8,
                    height: _ballRadius * 0.8,
                  ),

                ],
              ),
              Container(height: 20,)
           ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();

    super.dispose();
  }
}

class BouncingBallWidget extends StatelessWidget {
  final Animation<double> animation;
  final String imagePath;
  final double width;
  final double height;

  const BouncingBallWidget({
    required this.animation,
    required this.imagePath,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Image.asset(imagePath, width: width, height: height),
    );
  }
}
