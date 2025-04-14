import 'package:flutter/material.dart';

class GestureAnimationCat extends StatefulWidget {
  const GestureAnimationCat({super.key});

  @override
  State<GestureAnimationCat> createState() => _GestureAnimationCatState();
}

class _GestureAnimationCatState extends State<GestureAnimationCat> {
  double angleX = 0;
  double angleY = 0;

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final dx = details.localPosition.dx;
    final dy = details.localPosition.dy;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final normX = ((dx - centerX) / centerX).clamp(-1.0, 1.0);
    final normY = ((dy - centerY) / centerY).clamp(-1.0, 1.0);

    setState(() {
      angleY = -normX * 0.8;
      angleX = normY * 0.5;
    });
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() {
      angleX = 0;
      angleY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gesture Animation Cat',
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onPanUpdate:
                          (details) => _onPanUpdate(details, screenSize),
                      onPanEnd: _onPanEnd,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: angleX),
                        duration: const Duration(milliseconds: 200),
                        builder: (_, x, __) {
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: angleY),
                            duration: const Duration(milliseconds: 200),
                            builder: (_, y, __) {
                              return Column(
                                children: [
                                  Transform(
                                    alignment: Alignment.bottomCenter,
                                    transform:
                                        Matrix4.identity()
                                          ..setEntry(3, 2, 0.003)
                                          ..rotateX(angleX)
                                          ..rotateY(angleY),
                                    child: Container(
                                      padding: EdgeInsets.only(top: 50),
                                      width: 500,
                                      height: 500,
                                      child: Image.asset(
                                        'assets/cat2.png',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
