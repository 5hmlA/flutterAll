import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';

/// 首个view 不旋转  折叠的时候 有下面一个view折叠后绘制的，但是下面的view还暂着空间
/// 非首个view都支持旋转，折叠之后(1)变为上个view 只显示自己的折叠状态
/// 缺点是当完全折叠之后 只有首个位置能看到view但是显示的背景view是第二个view折叠后的，所以实际上第二个view还占着位置
class FoldCard extends StatefulWidget {
  final List<Container>? childs;

  /// true 折叠 动画为展开 1-0
  final bool foldState;
  final Widget? foldChild;
  final backgroundColor;

  FoldCard({Key? key,this.childs, this.foldChild, this.foldState = false, this.backgroundColor = Colors.white}) : super(key: key);

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

  void toggle() {
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
      _animationControl = AnimationController(vsync: this, duration: Duration(seconds: 12 * (childSize / 3).floor()));
    }
    _animationControl.addListener(() {
      setState(() {});
    });

    animation = _animationControl.drive(CurveTween(curve: Curves.easeIn));
    if (widget.foldState) {
      /// 折叠状态
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

  /// 首个view 不旋转  折叠的时候在下面显示
  /// 非首个view都支持旋转，折叠之后(1)变为上个view 只显示自己的折叠状态
  /// 缺点是当完全折叠之后 只有首个位置能看到view但是显示的背景view是第二个view折叠后的，所以实际上第二个view还占着位置
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

/// 沿着顶部的x轴旋转，向上表示折叠，向下表示展开 animation 1 表示 折叠后显示backChild，0表示正常显示child  1为折叠 0为展开
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

/// ======================= demo ===============================
//region FoldingBoxDemo
class FoldCardDemo extends StatelessWidget {
  List<String> titles = [
    "Fold",
    "Arithmetic",
    "Breathe",
    // "SnowMain",
    // "BlendokuPage",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(50),
          child: buildListView(),
        ));
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int inde) {
        return FoldCard(
            key: ValueKey(inde),
            foldState: inde == 0,
            childs: List.generate(titles.length, (index) {
              if (index == 0) {
                return Container(
                  width: 200,
                  height: 100,
                  child: Builder(
                    builder: (BuildContext context) => centerText(titles[index], color: Colors.primaries[index], onPressed: () {
                      FoldCard.of(context).toggle();
                    }),
                  ),
                );
              } else {
                return centerTextButton(titles[index], color: Colors.primaries[index], onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(titles[index])));
                });
              }
            }),
            foldChild: Container(
              child: Builder(
                  builder: (context) => centerText("Unfold", color: randomColor(), onPressed: () {
                    FoldCard.of(context).toggle();
                  })),
            ));
      },
    );
  }
}
//endregion
