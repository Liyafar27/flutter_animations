import 'dart:math';

import 'package:flutter/material.dart';

class NeonWavePage extends StatefulWidget {
  @override
  _NeonWavePageState createState() => _NeonWavePageState();
}

class _NeonWavePageState extends State<NeonWavePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _phase = 0.0;
  late List<double> _starOpacities;
  final int numStars = 50;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 360))
          ..addListener(() {
            setState(() {
              _phase = (_phase + 0.01) % (10 * pi);
            });
          })
          ..repeat();

    _starOpacities = List.generate(numStars, (index) => Random().nextDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Painter Animation',
          style: TextStyle(
            color: Colors.blueAccent.shade100,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: NeonWavePainter(_phase, _starOpacities),
        child: Container(),
      ),
    );
  }
}

class NeonWavePainter extends CustomPainter {
  final double phase;
  final List<double> starOpacities;

  NeonWavePainter(this.phase, this.starOpacities);

  @override
  void paint(Canvas canvas, Size size) {
    final seaPaint =
        Paint()
          ..color = Colors.cyanAccent.withOpacity(0.07)
          ..style = PaintingStyle.fill;

    final seaPath =
        Path()
          ..moveTo(0, size.height * 0.1)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, size.height * 0.1)
          ..close();

    canvas.drawPath(seaPath, seaPaint);

    _drawSky(canvas, size);
    _drawWave(
      canvas,
      size,
      5.5,
      Colors.blue.withOpacity(0.1),
      10,
      1.0,
      0.6,
      MaskFilter.blur(BlurStyle.normal, 5),
    );
    _drawWave(
      canvas,
      size,
      6.5,
      Colors.blue.shade900.withOpacity(0.1),
      15,
      1.0,
      0.6,
      MaskFilter.blur(BlurStyle.normal, 15),
    );
    _drawWave(
      canvas,
      size,
      7.5,
      Colors.blueAccent.withOpacity(0.2),
      25,
      1.0,
      0.6,
      MaskFilter.blur(BlurStyle.normal, 15),
    );
    _drawWave(
      canvas,
      size,
      8,
      Color(0xFF020617).withOpacity(0.3),
      15,
      1.0,
      0.6,
      MaskFilter.blur(BlurStyle.normal, 25),
    );
    _drawWave(
      canvas,
      size,
      7,
      Colors.blue.shade900.withOpacity(0.5),
      20,
      1.0,
      0.6,
      MaskFilter.blur(BlurStyle.outer, 10),
    );
    _drawWave(
      canvas,
      size,
      5,
      Colors.blue.shade400.withOpacity(0.3),
      20,
      1.5,
      0.6,
      MaskFilter.blur(BlurStyle.outer, 10),
    );
    _drawWave(
      canvas,
      size,
      5,
      Colors.blue.shade900.withOpacity(0.4),
      15,
      1,
      0.6,
      MaskFilter.blur(BlurStyle.outer, 10),
    );

    _drawWave(
      canvas,
      size,
      5.5,
      Colors.lightBlueAccent.withOpacity(0.4),
      30,
      1.5,
      0.6,
      MaskFilter.blur(BlurStyle.outer, 6),
    );
    _drawWave(
      canvas,
      size,
      8,
      Colors.blueAccent.withOpacity(0.2),
      33,
      1.0,
      0.6,
      MaskFilter.blur(BlurStyle.outer, 5),
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double speed,
    Color color,
    double amplitude,
    double zoom,
    double heightFactor,
    MaskFilter blurStyle,
  ) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..maskFilter = blurStyle;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      double y =
          size.height * heightFactor -
          amplitude * sin((x / size.width * 1.3 * pi * zoom) + phase * speed);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawSky(Canvas canvas, Size size) {
    final backgroundPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.black,
              Colors.blueGrey.shade900.withOpacity(0.0005),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final moonCenter = Offset(size.width - 100, 100);
    final moonRadius = 30.0;

    canvas.drawCircle(
      moonCenter,
      moonRadius,
      Paint()
        ..color = Colors.yellowAccent.shade700
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(
      moonCenter,
      moonRadius,
      Paint()..color = Colors.yellowAccent.shade100,
    );

    canvas.drawCircle(
      Offset(moonCenter.dx + 10, moonCenter.dy),
      moonRadius,
      Paint()
        ..blendMode = BlendMode.darken
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
    );

    final random = Random(0);

    for (int i = 0; i < starOpacities.length; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height * 0.5;
      double radius = random.nextDouble() * 1 + 0.5;

      final starPaint =
          Paint()..color = Colors.white.withOpacity(starOpacities[i]);

      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
