import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterf/ui/ani/ClickScaleFeedback.dart';
import 'package:flutterf/ui/pageroute/OpenTvPageRoute.dart';
import 'package:flutterf/ui/snow/snowman.dart';

class Arithmetic extends StatelessWidget {
  /// 多个接收者必须broadcast
  StreamController inputStreamController = StreamController.broadcast();
  StreamController scoreStreamController = StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: (){
            Navigator
                .of(context)
                .push(OpenTvPageRoute(child: SnowMain()));
          },
          child: StreamBuilder(
            // stream: inputStreamController.stream,
            stream: scoreStreamController.stream.transform(ScoreTransform()),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              print("${snapshot.hasData} score: ${snapshot.data.toString()}");
              if (snapshot.hasData) {
                return Text("score: ${snapshot.data.toString()}");
              }
              return Text("waiting");
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            /// ... 把list拆分
            ...List.generate(2, (index) => CapsuleLayout(inputStreamController.stream, scoreStreamController)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Keyboard(inputStreamController),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreTransform extends StreamTransformerBase {
  num scoreTotal = 0;
  StreamController _streamController = StreamController();

  @override
  Stream bind(Stream stream) {
    stream.listen((event) {
      print("==== $event");

      _streamController.add(scoreTotal += event);
    });
    return _streamController.stream;
  }
}

class Capsule extends StatelessWidget {
  int a = Random().nextInt(8), b = 9;
  Color _color = Colors.primaries.elementAt(Random().nextInt(Colors.primaries.length)).withAlpha(Random().nextInt(100));

  // Capsule(){
  //   b = Random().nextInt(9 - a);
  // }

  @override
  Widget build(BuildContext context) {
    b = Random().nextInt(9 - a);
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        color: _color,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text("$a + $b"),
        ),
      ),
    );
  }

  int sum() {
    return a + b;
  }
}

class CapsuleLayout extends StatefulWidget {
  final Stream stream;
  final StreamController scoreStreamController;

  CapsuleLayout(this.stream, this.scoreStreamController);

  @override
  _CapsuleLayout createState() => _CapsuleLayout();
}

class _CapsuleLayout extends State<CapsuleLayout> with SingleTickerProviderStateMixin {
  double x = Random().nextInt(360).toDouble(), y = Random().nextInt(360).toDouble(), velocity = Random().nextInt(2).toDouble() + 2;
  Capsule _child = Capsule();
  late AnimationController _animationControl;
  double height = 200;

  @override
  void initState() {
    // height = MediaQuery.of(context).size.height;
    super.initState();

    _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

    widget.stream.listen((event) {
      if (event == _child.sum()) {
        widget.scoreStreamController.add(velocity);
        reset();
      }
    });
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  void reset() {
    x = Random().nextInt(280).toDouble();
    y = Random().nextInt(60).toDouble();
    velocity = Random().nextInt(4).toDouble() + 2;
    _child = Capsule();
  }

  @override
  Widget build(BuildContext context) {
    // if (score) {
    //   return AnimatedSize(
    //     duration: Duration(seconds: 3),
    //     vsync: this,
    //     child: _child,
    //   );
    // }
    // ScaleTransition();

    return AnimatedBuilder(
      animation: _animationControl,
      builder: (BuildContext context, Widget? child) {
        final top = y += velocity;
        final left = x;
        if (top > MediaQuery.of(context).size.height - 300) {
          widget.scoreStreamController.add(-velocity);
          reset();
        }
        return Positioned(
          top: top,
          left: left,
          child: _child,
        );
      },
    );
  }
}

class Keyboard extends StatefulWidget {
  final StreamController? _streamController;

  Keyboard(this._streamController);

  @override
  _KeyboardState createState() => _KeyboardState();

  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1.5,
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
          9,
          (index) => ClickScale(
                onTap: () {
                  _streamController?.add(index + 1);
                },
                child: RaisedButton(
                  onPressed: () {},
                  child: Text((index + 1).toString()),
                  shape: RoundedRectangleBorder(),
                  color: Colors.primaries.elementAt(index),
                ),
              )),
    );
  }

  void dispose() {
    _streamController?.sink.close();
  }
}

class _KeyboardState extends State<Keyboard> {
  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
}
