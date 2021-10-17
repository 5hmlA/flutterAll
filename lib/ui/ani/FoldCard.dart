import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';

class FoldCard extends StatefulWidget {
  final List<Container>? childs;

  final bool fold;
  final Widget? foldChild;
  final backgroundColor;

  FoldCard({this.childs, this.foldChild, this.fold = false, this.backgroundColor = Colors.white}) : super(key: ObjectKey(childs.hashCode));

  static FoldCardState of(BuildContext context) {
    return context.findAncestorStateOfType<FoldCardState>()!;
  }

  @override
  FoldCardState createState() => FoldCardState();
}

class FoldCardState extends State<FoldCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;
  late List<Animation<double>> _animations;
  late Animation<double> animation;
  var childSize = 0;
  double aniChangeHeight = 0;
  double minHeight = 0;

  void expand() {
    if (_animationControl.value == 1) {
      _animationControl.reverse();
    } else {
      _animationControl.forward();
    }
  }

  void toTold() {
    if (_animationControl.value == 1) {
      _animationControl.reverse();
    } else {
      _animationControl.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    aniChangeHeight = widget.childs!.map((e) => e.constraints!.maxHeight).reduce((value, element) => value + element);
    minHeight = widget.childs!.first.constraints!.maxHeight;
    aniChangeHeight = aniChangeHeight - minHeight;
    childSize = widget.childs!.length;
    if (childSize < 3) {
      _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 1));
    } else {
      _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 2 * (childSize / 3).floor()));
    }
    _animationControl.addListener(() {
      setState(() {});
    });

    animation = _animationControl.drive(CurveTween(curve: Curves.easeIn));
    if (widget.fold) {
      animation = Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)).animate(_animationControl);
    }
    double interval = 1.0 / (childSize - 1);

    _animations = List.generate(childSize - 1, (index) => CurveTween(curve: Interval(index * interval, (index + 1) * interval)).animate(animation))
        .reversed
        .toList();
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: minHeight*2 + aniChangeHeight*(1-animation.value),
      child: Column(
        children: List.generate(childSize, (index) {
          Container child = widget.childs![index];
          if (index == 0) {
            return child;
          }
          var background = Container(
            width: child.constraints!.maxWidth,
            height: child.constraints!.maxHeight,
            color: widget.backgroundColor,
          );
          if (index == 1) {
            if (childSize > 2) {
              return RotationAni(
                            animation: _animations[index - 1],
                            holderChild: child,
                            child: background,
                            backChild: widget.foldChild!,
                            goneAfterFold: false,
                          );
            } else {
              return RotationAni(
                animation: _animations[index - 1],
                holderChild: child,
                child: child,
                backChild: widget.foldChild!,
                goneAfterFold: false,
              );
            }
          } else if (index == childSize - 1) {
            return RotationAni(
              animation: _animations[index - 1],
              child: child,
              backChild: background,
            );
          } else {
            return RotationAni(
              animation: _animations[index - 1],
              holderChild: child,
              child: background,
              backChild: background,
            );
          }
        }),
      ),
    );
  }
}

/// 沿着顶部的x轴旋转，向上表示折叠，向下表示展开 animation 1 表示 折叠后显示backChild，0表示正常显示child
class RotationAni extends AnimatedWidget {
  late final Animation<double> animation;
  late final Widget? child;
  late final Widget? backChild;
  late final Widget? holderChild;
  late final bool goneAfterFold;

  RotationAni({Key? key, required this.animation, this.holderChild, this.child, this.goneAfterFold = true, backChild})
      : super(key: key, listenable: animation) {
    if (!goneAfterFold) {
      this.backChild = Transform(
        transform: Matrix4.rotationX(pi),
        alignment: AlignmentDirectional.center,
        child: backChild,
      );
    } else {
      this.backChild = backChild;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (animation.value == 0 && holderChild != null) {
      return holderChild!;
    }

    final progress = animation.value * pi;
    if (progress == pi && goneAfterFold) {
      return SizedBox.shrink();
    }
    final showChild = progress <= pi / 2 ? child : backChild;
    return Transform(transform: Matrix4.rotationX(progress), alignment: AlignmentDirectional.topCenter, child: showChild);
  }
}
