import 'package:flutter/material.dart';

class NeonBrainPage extends StatefulWidget {
  const NeonBrainPage({super.key});

  @override
  State<NeonBrainPage> createState() => _NeonBrainPageState();
}

class _NeonBrainPageState extends State<NeonBrainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 8.0,
      end: 20.0,
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
          'Neon Glow Animation',
          style: TextStyle(
            color: Colors.purple.shade100,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,

          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.6),
                        blurRadius: _glowAnimation.value,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset('assets/brain.png', width: 250),
                );
              },
            ),
            ..._buildNeuroSignals(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNeuroSignals() {
    return List.generate(15, (i) {
      return RandomNeuroPulseDot(
        color: [
          Colors.purple,
          Colors.deepPurple,
          Colors.purpleAccent,
          Colors.pink,
          Colors.purpleAccent,
          Colors.pinkAccent,
        ][i % 6].withOpacity(0.9),
      );
    });
  }
}

class PositionedNeuroDot extends StatefulWidget {
  final int delay;
  final List<Offset> path;
  final Color color;

  const PositionedNeuroDot({
    super.key,
    required this.delay,
    required this.path,
    required this.color,
  });

  @override
  State<PositionedNeuroDot> createState() => _PositionedNeuroDotState();
}

class _PositionedNeuroDotState extends State<PositionedNeuroDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    final tween = TweenSequence<Offset>(
      List.generate(widget.path.length - 1, (i) {
        return TweenSequenceItem(
          tween: Tween(
            begin: widget.path[i],
            end: widget.path[i + 1],
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        );
      }),
    );

    _animation = tween.animate(_controller);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Align(
          alignment: Alignment(_animation.value.dx, _animation.value.dy),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.7),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RandomNeuroPulseDot extends StatefulWidget {
  final Color color;

  const RandomNeuroPulseDot({super.key, required this.color});

  @override
  State<RandomNeuroPulseDot> createState() => _RandomNeuroPulseDotState();
}

class _RandomNeuroPulseDotState extends State<RandomNeuroPulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Offset position;

  @override
  void initState() {
    super.initState();
    final randX = () => (-0.15 + (0.35 * (UniqueKey().hashCode % 1000) / 1000));
    final randY =
        () =>
            (-0.15 +
                (0.25 *
                    (UniqueKey().hashCode % 1000) /
                    1000)); // Уже не от -0.4 до 0.4, а от -0.2 до 0.2

    // Случайная позиция внутри мозга (по ощущениям — можно подогнать)
    // final rand = () => (-0.35 + (0.6 * (UniqueKey().hashCode % 1000) / 1000));
    position = Offset(randX(), randY());

    _controller = AnimationController(
      duration: Duration(
        milliseconds: 1800 + (position.dx * 800).abs().toInt(),
      ),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(position.dx, position.dy),
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          width: 2,
          height: 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.7),
                blurRadius: 8,
                spreadRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
