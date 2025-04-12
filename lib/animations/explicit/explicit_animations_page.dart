import 'package:flutter/material.dart';

class ExplicitAnimationsPage extends StatefulWidget {
  @override
  _ExplicitAnimationsPageState createState() => _ExplicitAnimationsPageState();
}

class _ExplicitAnimationsPageState extends State<ExplicitAnimationsPage> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _textScaleAnimation;

  late AnimationController _heartController;
  late Animation<double> _heartSizeAnimation;
  late Animation<Color?> _heartColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sizeAnimation = Tween<double>(begin: 50, end: 120).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(begin: Colors.purpleAccent, end: Colors.blueAccent).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _positionAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -0.5)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textScaleAnimation = Tween<double>(begin: 0.6, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _heartController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _heartSizeAnimation = Tween<double>(begin: 50, end: 80).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );

    _heartColorAnimation = ColorTween(begin: Colors.red, end: Colors.pink).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Explicit Animations', style: TextStyle(
          color: Colors.lightBlue,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _positionAnimation.value,
                  child: Container(
                    width: _sizeAnimation.value,
                    height: _sizeAnimation.value,
                    decoration: BoxDecoration(
                      color: _colorAnimation.value,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: _colorAnimation.value!.withOpacity(0.6),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.headphones,
                        size: _sizeAnimation.value / 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _textScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _textScaleAnimation.value,
                  child: Text(
                    'Explicit Animations',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(_heartSizeAnimation.value, _heartSizeAnimation.value),
                  painter: HeartPainter(_heartColorAnimation.value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final Color? color;
  HeartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.red
      ..style = PaintingStyle.fill;
    final Paint glowPaint = Paint()
      ..color = (color ?? Colors.red).withOpacity(0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    final double width = size.width;
    final double height = size.height;

    final path = Path()
      ..moveTo(width / 2, height * 0.35)
      ..cubicTo(
        width * 0.15, 0,
        0, height * 0.5,
        width / 2, height,
      )
      ..cubicTo(
        width, height * 0.5,
        width * 0.85, 0,
        width / 2, height * 0.35,
      )
      ..close();
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
