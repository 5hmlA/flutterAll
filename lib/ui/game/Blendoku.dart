import 'package:flutter/material.dart';
import 'package:flutterf/ui/Colors.dart';

const double size = 100;

class BlendokuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blendoku"),
      ),
      body: Blendoku(),
    );
  }
}

class Blendoku extends StatefulWidget {
  @override
  _BlendokuState createState() => _BlendokuState();
}

class _BlendokuState extends State<Blendoku> {
  MaterialColor _color = Colors.red;
  var _colors = [];

  @override
  void initState() {
    _colors = [
      _color[100],
      _color[200],
      _color[300],
      _color[400],
      _color[500],
      _color[600],
      _color[700],
      _color[800],
      _color[900],
    ]..shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 140),
        color: Colors.blueAccent,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: List.generate(
              4,
              (index) => BlendokuWithPosition(
                    index * (size + 8),
                    0,
                    _colors.elementAt(index),
                    (data) {
                      print("dragupdate ${data.localPosition.dy}");
                      print("dragupdate ${data.globalPosition.dy}");
                    },
                  )),
        ),
      ),
    );
  }
}

@immutable
class BlendokuWithPosition extends StatelessWidget {
  final double top;
  final double left;
  final Color color;
  final DragUpdateCallback? onDragUpdate;

  const BlendokuWithPosition(this.top, this.left, this.color, this.onDragUpdate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var container = blockC(color);
    return AnimatedPositioned(
      top: top,
      left: left,
      duration: Duration(seconds: 2),
      child: Draggable(
        feedback: container,
        child: container,
        childWhenDragging: Visibility(
          visible: false,
          child: container,
        ),
        onDragUpdate: onDragUpdate,
      ),
    );
  }
}

block([int index = -1]) {
  var color = index > -1 ? indexColor(index) : randomColor();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(width: 100, height: 100, color: color),
  );
}

Widget blockC(Color color) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(width: 100, height: 100, color: color),
  );
}
