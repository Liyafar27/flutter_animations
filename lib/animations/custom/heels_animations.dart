import 'package:flutter/material.dart';

class HeelWalkPage extends StatefulWidget {
  @override
  _HeelWalkPageState createState() => _HeelWalkPageState();
}

class _HeelWalkPageState extends State<HeelWalkPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leftHeelVertical;
  late Animation<double> _rightHeelVertical;
  late Animation<double> _horizontal;
  late Animation<double> _leftHeelTilt;
  late Animation<double> _rightHeelTilt;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 12),
      vsync: this,
    )..repeat();

    _horizontal = Tween<double>(begin: -1100, end: 1100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _leftHeelVertical = TweenSequence([
      for (int i = 0; i < 5; i++) ...[
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -30.0), weight: 0.9),
        TweenSequenceItem(tween: Tween(begin: -30.0, end: 0.0), weight: 0.9),
        TweenSequenceItem(tween: ConstantTween(0.0), weight: 1.0),
      ],
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _rightHeelVertical = TweenSequence([
      for (int i = 0; i < 5; i++) ...[
        TweenSequenceItem(tween: ConstantTween(0.0), weight: 1.0),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -30.0), weight: 0.9),
        TweenSequenceItem(tween: Tween(begin: -30.0, end: 0.0), weight: 0.9),
      ],
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _leftHeelTilt = TweenSequence([
      for (int i = 0; i < 5; i++) ...[
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 0.7),
        TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.1), weight: 0.4),
        TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 0.7),
        TweenSequenceItem(tween: ConstantTween(0.0), weight: 1.0),
      ],
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _rightHeelTilt = TweenSequence([
      for (int i = 0; i < 5; i++) ...[
        TweenSequenceItem(tween: ConstantTween(0.0), weight: 1.0),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 0.7),
        TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.1), weight: 0.4),
        TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 0.7),
      ],
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _heel(String assets , Animation<double> vertical, Animation<double> horizontal, Animation<double> tilt) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(horizontal.value, vertical.value),
          child: Transform.rotate(
            angle: tilt.value,
            child: child,
          ),
        );
      },
      child: Image.asset(
        assets,
        height: 150,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Heels walk animations',
          style: TextStyle(
            color: Colors.limeAccent,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 75,
                  top: MediaQuery.of(context).size.height / 2.75,
                  child: Row(
                    children: [
                      SizedBox(width: 100),
                      _heel('assets/heel1.png',_leftHeelVertical, _horizontal, _leftHeelTilt),
                      _heel('assets/heel1.png',_rightHeelVertical, _horizontal, _rightHeelTilt),
                      SizedBox(width: 100),
                      _heel('assets/heel2.png',_leftHeelVertical, _horizontal, _leftHeelTilt),
                      _heel('assets/heel2.png',_rightHeelVertical, _horizontal, _rightHeelTilt),
                      SizedBox(width: 100),
                      _heel('assets/heel.png',_leftHeelVertical, _horizontal, _leftHeelTilt),
                      _heel('assets/heel.png',_rightHeelVertical, _horizontal, _rightHeelTilt),
                      SizedBox(width: 100),

                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
