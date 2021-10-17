import 'package:flutter/cupertino.dart';

class OpenTvPageRoute<T> extends PageRoute<T> {
  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  final Widget child;

  OpenTvPageRoute({
    RouteSettings? settings,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    required this.child,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return AnimatedBuilder(
        animation: animation.drive(CurveTween(curve: Curves.easeOutQuint)),
        builder: (BuildContext context, Widget? child) {
          return ClipRect(clipper: OpenTvPathClipper(animation.value), child: child!);
        },
        child: child);
  }
}

class OpenTvPathClipper extends CustomClipper<Rect> {
  final double progress;

  OpenTvPathClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(center: size.center(Offset.zero), width: size.width, height: size.height * progress);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}
