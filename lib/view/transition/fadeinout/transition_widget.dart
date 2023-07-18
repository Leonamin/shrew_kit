import 'package:flutter/material.dart';

class TransitionWidget extends StatefulWidget {
  final Function()? onStart;
  final Function()? onMid;
  final Function()? onEnd;

  final Duration duration;
  final Duration midDuration;
  final Duration reverseDuration;

  final Widget child;
  final Widget Function(AnimationController) animationBuilder;

  const TransitionWidget({
    super.key,
    this.onStart,
    this.onMid,
    this.onEnd,
    this.duration = const Duration(milliseconds: 500),
    this.midDuration = const Duration(milliseconds: 0),
    this.reverseDuration = const Duration(milliseconds: 500),
    required this.child,
    required this.animationBuilder,
  });

  @override
  State<TransitionWidget> createState() => _TransitionWidgetState();
}

class _TransitionWidgetState extends State<TransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              widget.child,
              widget.animationBuilder(_controller),
            ],
          );
        });
  }

  void animateTransition() async {
    widget.onStart?.call();
    setState(() {
      isPlaying = !isPlaying;
    });
    _controller.forward().then((value) async {
      widget.onMid?.call();
      await Future.delayed(widget.midDuration);
      _controller.reverse().then((value) {
        setState(() {
          isPlaying = !isPlaying;
        });
      });
    });
    widget.onEnd?.call();
  }
}
