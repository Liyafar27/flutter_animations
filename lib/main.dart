import 'package:flutter/material.dart';
import 'package:flutter_animations_showroom/animations/hero/hero_animation_page.dart';

import 'animations/custom/custom_animation_heart.dart';
import 'animations/custom/wave_animations.dart';
import 'animations/implicit/implicit_animation_page.dart';
import 'animations/physics/car_animation.dart';
import 'animations/physics/physics_animation_page.dart';

void main() => runApp(FlutterAnimationsLab());

class FlutterAnimationsLab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: HomePage(),
    );
  }
}

class Section {
  final String title;
  final IconData icon;

  Section({required this.title, required this.icon});
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Color> neonColors = [
    Color(0xFFFF61F6).withValues(alpha: 0.1),
    Color(0xFF00FF99).withValues(alpha: 0.1),
    Color(0xFFFFFF61).withValues(alpha: 0.1),
    Color(0xFF61F6FF).withValues(alpha: 0.1),
    Color(0xFF872BDC).withValues(alpha: 0.1),
    Color(0xFFADFF2F).withValues(alpha: 0.1),
  ];
  final List<Section> sections = [
    Section(title: 'Implicit Animations', icon: Icons.auto_awesome),
    Section(title: 'Explicit Animations', icon: Icons.timeline),
    Section(title: 'Hero Animations', icon: Icons.flight_takeoff),
    Section(title: 'Physics-based', icon: Icons.attractions),
    Section(title: 'Custom + image', icon: Icons.extension),
    Section(title: 'Custom + painter', icon: Icons.bolt),
  ];


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openSection(Section section) {
    Widget page;

    switch (section.title) {
      case 'Implicit Animations':
        page = ImplicitAnimationsPage();
        break;
      case 'Explicit Animations':
        page = ExplicitAnimationsPage();
        break;
      case 'Hero Animations':
        page = HeroAnimationsPage();
        break;
      case 'Physics-based':
        page = PhysicsAnimationPage();
        break;
      case 'Custom + image':
        page = CarDrivePage();
        ;
        break;
      case 'Custom + painter':
        page = NeonWavePage();
        break;
      default:
        page = SectionPage(title: section.title); // fallback
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Animations Lab',
          style: TextStyle(
            color: Color(0xFFFF61F6),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: GridView.builder(
          itemCount: sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (_, i) {
            final delay = i * 0.1;
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    delay,
                    (delay + 0.6).clamp(0.0, 1.0), // защита от ошибки
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: NeonTile(
                section: sections[i],
                color: neonColors[i % neonColors.length], // цикл по цветам
                onTap: () => openSection(sections[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NeonTile extends StatefulWidget {
  final Section section;
  final VoidCallback onTap;
  final Color color;

  const NeonTile({
    required this.section,
    required this.onTap,
    required this.color,
  });

  @override
  State<NeonTile> createState() => _NeonTileState();
}

class _NeonTileState extends State<NeonTile> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _flickerController;
  late final Animation<double> _glowIntensity;
  late final Animation<Offset> _shakeAnimation;
  late final Animation<double> _flickerOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(period: const Duration(seconds: 3));

    _glowIntensity = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.005, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));

    _flickerOpacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
      TweenSequenceItem(tween: ConstantTween(0.4), weight: 5),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(0.8), weight: 5),
    ]).animate(_flickerController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _glowIntensity,
        _shakeAnimation,
        _flickerOpacity,
      ]),
      builder: (context, child) {
        final glow = widget.color.withOpacity(
          _glowIntensity.value * _flickerOpacity.value,
        );

        return Transform.translate(
          offset: _shakeAnimation.value * 8,
          child: InkWell(
            onTap: widget.onTap,
            splashColor: glow.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: glow, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: glow,
                    blurRadius: 12 + _glowIntensity.value * 10,
                    spreadRadius: 1,
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Colors.black, glow.withOpacity(0.01)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  widget.section.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,

                    shadows: [
                      Shadow(offset: Offset(-1, -1), color: Colors.black),
                      Shadow(offset: Offset(1, -1), color: Colors.black),
                      Shadow(offset: Offset(1, 1), color: Colors.black),
                      Shadow(offset: Offset(-1, 1), color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SectionPage extends StatelessWidget {
  final String title;

  const SectionPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Color(0xFFFF61F6))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFFF61F6)),
      ),
      body: const Center(
        child: Text(
          '🚧 Coming soon...',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
