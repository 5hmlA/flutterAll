import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Colors.dart';

class Folding extends StatefulWidget {
  final List<Container>? childs;
  final Decoration? decoration;
  final bool fold;
  final Container? foldChild;
  final backgroundColor;
  final BorderRadius? borderRadius;

  Folding({this.childs, this.foldChild, this.fold = true, this.decoration, this.borderRadius, this.backgroundColor = Colors.white})
      : super(key: ObjectKey(childs.hashCode));

  static FoldingState of(BuildContext context) {
    return context.findAncestorStateOfType<FoldingState>()!;
  }

  @override
  FoldingState createState() => FoldingState();
}

class FoldingState extends State<Folding> with SingleTickerProviderStateMixin {
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
      _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 1 * (childSize / 3).floor()));
    }
    _animationControl.addListener(() {
      setState(() {});
    });

    /// 0--1 展开
    animation = Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationControl);
    if (widget.fold) {
      animation = _animationControl.drive(CurveTween(curve: Curves.easeInOut));
    }
    if (childSize > 2) {
      double interval = 1.0 / (childSize - 1);
      _animations = List.generate(childSize - 1, (index) => CurveTween(curve: Interval(index * interval, (index + 1) * interval)).animate(animation));
    } else {
      _animations = [animation];
    }
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var result = foldAbleLayout(context);

    // result = ClipRRect(
    //   borderRadius: BorderRadius.all(Radius.circular(20)),
    //   child: result,
    // );
    if (widget.borderRadius != null) {
      result = ClipRRect(
        borderRadius: widget.borderRadius,
        child: result,
      );
    }
    return result;
  }

  foldAbleLayout(BuildContext context) {
    return Container(
      decoration: widget.decoration,
      height: minHeight + aniChangeHeight * (animation.value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(childSize - 1, (index) {
          Container child = widget.childs![index];
          var background = Container(
            width: child.constraints!.maxWidth,
            height: child.constraints!.maxHeight,
            color: widget.backgroundColor,
          );
          if (index == 0) {
            return Stack(
              fit: StackFit.passthrough,

              children: [child, getFirstAniHolder(index, background)],
            );
          }
          if (index == childSize - 2)
            return Flip(
              animation: _animations[index],
              child: widget.childs!.elementAt(index + 1),
              backChild: background,
              goneIfUnFold: false,
            );
          return Flip(
            animation: _animations[index],
            child: background,
            goneIfUnFold: false,
            backChild: background,

            /// 展开完全后显示下一个widget
            holderChild: widget.childs!.elementAt(1 + index),
          );
        }),
      ),
    );
  }

  getFirstAniHolder(int index, background) {
    if (childSize == 2) {
      return Flip(
        animation: _animationControl,
        child: widget.childs!.elementAt(1),
        holderChild: widget.childs!.elementAt(1),
        backChild: widget.foldChild!,
        goneIfUnFold: false,
        goneAfterFold: false,
      );
    }
    return Flip(
      animation: _animations[index],
      child: background,
      backChild: widget.foldChild!,

      /// 展开完全后显示下一个widget
      holderChild: widget.childs!.elementAt(1 + index),
      goneIfUnFold: false,
      goneAfterFold: false,
    );
  }
}

class FlipTest extends StatefulWidget {
  @override
  _FlipTestState createState() => _FlipTestState();
}

/// animation 0 反面 --- 1 正面
class _FlipTestState extends State<FlipTest> with SingleTickerProviderStateMixin {
  late AnimationController _animationControl;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    // _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = _animationControl.drive(Tween(begin: 0, end: 1));
    // animation = _animationControl.drive(Tween(begin: 1, end: 0));
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flip(
      animation: animation,
      goneAfterFold: false,
      goneIfUnFold: false,
      child: centerText("正面", onPressed: () {
        if (_animationControl.value == 1) {
          _animationControl.reverse();
        } else {
          _animationControl.forward();
        }
      }),
      backChild: centerText("反面", onPressed: () {
        if (_animationControl.value == 1) {
          _animationControl.reverse();
        } else {
          _animationControl.forward();
        }
      }),
    );
  }
}

/// 沿着底部的x轴旋转，///0反面(未旋转/未展开) --- 1 正面(旋转后//展开后)  向下翻转 翻转出下一个页面的正面
class Flip extends AnimatedWidget {
  late final Animation animation;
  late final Widget? child;
  late final Container? backChild;
  Widget? holderChild;
  late final bool goneIfUnFold;
  late final bool goneAfterFold;

  Flip({Key? key, required this.animation, holderChild, child, this.goneIfUnFold = false, this.goneAfterFold = true, this.backChild})
      : super(key: key, listenable: animation) {
    if (!goneIfUnFold) {
      this.child = Transform(
        transform: Matrix4.rotationX(pi),
        alignment: AlignmentDirectional.center,
        child: child,
      );
    } else {
      this.child = child;
    }

    print("<<<<<<<<<< $holderChild");
    if (holderChild != null) {
      this.holderChild = Transform(
        transform: Matrix4.rotationX(pi),
        alignment: AlignmentDirectional.center,
        child: holderChild,
      );
    } else {
      this.holderChild = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = animation.value * pi;
    if (progress == 0 && goneAfterFold) {
      ///折叠起来之后就不需要占位置了
      return SizedBox.shrink();
    }
    if (progress == pi && goneIfUnFold) {
      //得告诉父布局 占个位置
      return SizedBox(
        height: backChild!.constraints!.maxHeight,
      );
    }

    ///0反面(未旋转/未展开) --- 1 正面(旋转后//展开后)
    var showChild = progress <= pi / 2 ? backChild : child;
    if (holderChild != null && progress == pi) {
      ///完全展开后显示的widget
      showChild = holderChild;
    }
    return Transform(transform: Matrix4.rotationX(progress), alignment: AlignmentDirectional.bottomCenter, child: showChild);
  }

}
