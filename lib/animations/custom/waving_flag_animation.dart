import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WavingFlag extends StatefulWidget {
  const WavingFlag({super.key});

  @override
  State<WavingFlag> createState() => _WavingFlagState();
}

class _WavingFlagState extends State<WavingFlag>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  Future<void> _loadImage() async {
    final image = await loadUiImage('assets/flag.png');
    final resizedImage = await resizeImage(
      image,
      400,
    ); // Уменьшаем изображение до нужного размера (300px по ширине)

    setState(() {
      _image = resizedImage;
    });
  }

  Future<ui.Image> resizeImage(ui.Image image, int width) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        Offset(0, 0),
        Offset(width.toDouble(), image.height.toDouble()),
      ),
    );
    final paint = Paint();

    final scale = width / image.width;
    final newHeight = (image.height * scale).toDouble();

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), newHeight),
      paint,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, newHeight.toInt());
    return img;
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(context).load(assetPath);
    final list = Uint8List.view(data.buffer);
    final codec = await ui.instantiateImageCodec(list);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text(
          'Flag Wave Animation',
          style: TextStyle(
            color: Colors.blueGrey.shade200,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          FittedBox(
            fit: BoxFit.contain, // Сохраняем пропорции и масштабируем
            child: CustomPaint(
              // Рисуем шевелящийся флаг
              painter: FlagPainter(_image!, _controller),
              size: Size(400, 300),
            ),
          ),
          CustomPaint(
            // Маска сверху
            painter: FlagOverlayPainter(_image!),
            size: Size(400, 300),
          ),
        ],
      ),
    );
  }
}

class FlagOverlayPainter extends CustomPainter {
  final ui.Image image;

  FlagOverlayPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    const staticWidth = 90.0;

    for (double y = 0; y < image.height; y++) {
      final src = Rect.fromLTWH(0, y, staticWidth, 1);
      final dst = Rect.fromLTWH(0, y, staticWidth, 1);
      canvas.drawImageRect(image, src, dst, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FlagPainter extends CustomPainter {
  final ui.Image image;
  final Animation<double> animation;

  FlagPainter(this.image, this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const waveHeight = 7.0;
    const waveLength = 90.0;
    const staticWidth = 50.0; // НЕ шевелим первые 20 пикселей по X

    for (double y = 0; y < image.height; y++) {
      // 1. Сначала рисуем левый (статичный) кусочек
      final srcStatic = Rect.fromLTWH(0, y, staticWidth, 1);
      final dstStatic = Rect.fromLTWH(0, y, staticWidth, 1);
      canvas.drawImageRect(image, srcStatic, dstStatic, paint);

      // 2. Потом — остальную шевелящуюся часть
      final dx = sin((y / waveLength + animation.value * 2 * pi)) * waveHeight;
      final srcWaving = Rect.fromLTWH(
        staticWidth,
        y,
        image.width - staticWidth,
        1,
      );
      final dstWaving = Rect.fromLTWH(
        staticWidth + dx,
        y,
        image.width - staticWidth,
        1,
      );
      canvas.drawImageRect(image, srcWaving, dstWaving, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FlagPainter oldDelegate) => true;
}
