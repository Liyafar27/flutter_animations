import 'package:flutter/material.dart';

class HeelWalkPage extends StatefulWidget {
  @override
  _HeelWalkPageState createState() => _HeelWalkPageState();
}

class _HeelWalkPageState extends State<HeelWalkPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _upDown1;
  late Animation<double> _upDown2;
  late Animation<double> _tilt1;
  late Animation<double> _tilt2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _upDown1 = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _upDown2 = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _tilt1 = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _tilt2 = Tween<double>(begin: 0.05, end: -0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _heel(Animation<double> vertical, Animation<double> tilt) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, vertical.value),
          child: Transform.rotate(
            angle: tilt.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        'assets/heel.png',
        height: 150,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _heel(_upDown1, _tilt1), // левая
            SizedBox(width: 40),
            _heel(_upDown2, _tilt2), // правая (тоже глядит вправо)
          ],
        ),
      ),
    );
  }
}
