import 'package:flutter/material.dart';

class ImplicitAnimationsPage extends StatefulWidget {
  @override
  _ImplicitAnimationsPageState createState() => _ImplicitAnimationsPageState();
}

class _ImplicitAnimationsPageState extends State<ImplicitAnimationsPage> {
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Implicit Animations',
          style: TextStyle(
            color: Colors.limeAccent,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: _toggle ? 60 : 90,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: _toggle ? Colors.pinkAccent : Colors.greenAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_toggle ? 5 : 15),
                  topRight: Radius.circular(_toggle ? 5 : 15),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedIcon(
                  Colors.blueAccent,
                  Colors.purpleAccent,
                  Icons.check_circle_outline,
                ),
                SizedBox(width: 20),
                _buildAnimatedIcon(
                  Colors.deepPurpleAccent,
                  Colors.tealAccent,
                  Icons.favorite,
                ),
                SizedBox(width: 20),
                _buildAnimatedIcon(
                  Colors.blueAccent,
                  Colors.purpleAccent,
                  Icons.check_circle_outline,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _toggle = !_toggle;
                });
              },
              child: Text(
                'Toggle Animations',
                style: TextStyle(
                  color: Colors.limeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: _toggle ? 60 : 90,
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: _toggle ? Colors.lightGreenAccent : Colors.purpleAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_toggle ? 5 : 15),
                  bottomRight: Radius.circular(_toggle ? 5 : 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(Color color1, Color color2, IconData icon) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      width: _toggle ? 60 : 90,
      height: _toggle ? 60 : 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1.withOpacity(0.6), color2.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: color2.withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(60),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child:
              _toggle
                  ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : Icon(icon, color: Colors.greenAccent, size: 60),
        ),
      ),
    );
  }
}
