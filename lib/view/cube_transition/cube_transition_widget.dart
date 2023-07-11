import 'package:flutter/material.dart';

class CubeTransitionWidget extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Alignment alignment;
  final Widget enterWidget;
  final Widget exitWidget;
  final Function()? onEnter;

  const CubeTransitionWidget({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    required this.enterWidget,
    required this.exitWidget,
    this.onEnter,
  });

  @override
  State<CubeTransitionWidget> createState() => _CubeTransitionWidgetState();
}

class _CubeTransitionWidgetState extends State<CubeTransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.forward().then((value) => widget.onEnter?.call());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(_controller),
          child: Container(
            color: Colors.white,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.003)
                ..rotateY(3.14159 / 2 * _controller.value),
              alignment: FractionalOffset.centerRight,
              child: widget.enterWidget,
            ),
          ),
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_controller),
          child: Container(
            color: Colors.white,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.003)
                ..rotateY(3.14159 / 2 * (_controller.value - 1)),
              alignment: FractionalOffset.centerLeft,
              child: widget.exitWidget,
            ),
          ),
        ),
      ],
    );
  }
}

class _CubeSlideWidget extends StatelessWidget {
  _CubeSlideWidget({
    super.key,
    required this.animation,
    required this.isEnter,
    required this.child,
  }) {
    if (isEnter) {
      alignment = FractionalOffset.centerRight;
      beginOffset = const Offset(-1.0, 0.0);
    } else {
      alignment = FractionalOffset.centerLeft;
      beginOffset = const Offset(1.0, 0.0);
    }
  }

  final Animation<double> animation;
  final Widget child;
  final bool isEnter;

  late final AlignmentGeometry alignment;
  late final Offset beginOffset;

  double get animationValue {
    if (isEnter) {
      return animation.value;
    } else {
      return 1 - animation.value;
    }
  }

  double get rotateValueY => animationValue * 3.14159 / 2;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..rotateY(rotateValueY),
      alignment: alignment,
      child: child,
    );
    // return SlideTransition(
    //   position: Tween<Offset>(
    //     begin: beginOffset,
    //     end: Offset.zero,
    //   ).animate(animation),
    //   child: Transform(
    //     transform: Matrix4.identity()
    //       ..setEntry(3, 2, 0.003)
    //       ..rotateY(rotateValueY),
    //     alignment: alignment,
    //     child: child,
    //   ),
    // );
  }
}
