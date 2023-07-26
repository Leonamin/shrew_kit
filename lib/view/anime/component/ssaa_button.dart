import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shrew_kit/view/anime/component/check_button.dart';

// Simplified Single-Action Animated Button
class SSAAButton extends StatefulWidget {
  const SSAAButton({
    super.key,
    required this.isCompleted,
    this.width,
    this.height,
    this.onPressed,
  });
  final bool isCompleted;
  final double? width;
  final double? height;
  final Function()? onPressed;

  @override
  State<SSAAButton> createState() => _SSAAButtonState();
}

class _SSAAButtonState extends State<SSAAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      // reverseDuration: Duration(milliseconds: 100),
    );

    _sizeTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller.view,
        curve: Curves.ease,
      ),
    )..addStatusListener((status) {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: -0.2 * sin(2 * pi * _sizeTween.value) + 1,
          child: CheckButton(
            isCompleted: widget.isCompleted,
            width: widget.width,
            height: widget.height,
            onPressed: () {
              // _controller.forward().then((value) => _controller.reverse());
              _controller.forward().then((value) => _controller.reset());
              widget.onPressed?.call();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
