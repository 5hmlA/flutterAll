import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Breathe extends StatefulWidget {
  @override
  _BreatheState createState() => _BreatheState();
}

class _BreatheState extends State<Breathe> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _4Animation;
  late Animation _8Animation;

  @override
  void initState() {
    _animationController = AnimationController(duration: Duration(seconds: 20), vsync: this);

    _animationController.duration = Duration(seconds: 20);

    _4Animation = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Interval(0, .2))).animate(_animationController);
    _8Animation = Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Interval(.5, .9))).animate(_animationController);

    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AnimatedBuilder(
        builder: (BuildContext context, Widget? child) {
          double stops = _4Animation.value == 1 ? _8Animation.value : _4Animation.value;
          return Container(
            height: 300,
            decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: RadialGradient(
                  stops: [stops, stops + .2],
                  colors: [Colors.blue, Colors.blue.shade100],
                )),
          );
        },
        animation: _animationController,
      ),
    );
  }
}
