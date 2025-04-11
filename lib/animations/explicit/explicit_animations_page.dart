import 'package:flutter/material.dart';

class ExplicitAnimationsPage extends StatefulWidget {
  @override
  _ExplicitAnimationsPageState createState() => _ExplicitAnimationsPageState();
}

class _ExplicitAnimationsPageState extends State<ExplicitAnimationsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _textScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Контроллер анимации
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // повторяем анимацию с реверсом

    // Анимация размера
    _sizeAnimation = Tween<double>(
      begin: 50,
      end: 120,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Анимация цвета
    _colorAnimation = ColorTween(
      begin: Colors.purpleAccent,
      end: Colors.blueAccent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Анимация перемещения
    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textScaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Explicit Animations',
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
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

            Positioned(
              top: 100,
              child: AnimatedBuilder(
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
            ),
          ],
        ),
      ),
    );
  }
}
