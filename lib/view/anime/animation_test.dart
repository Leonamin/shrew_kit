import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shrew_kit/view/anime/component/check_button.dart';

class AnimationTest extends StatefulWidget {
  const AnimationTest({super.key});

  @override
  State<AnimationTest> createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation colorTween;
  late final Animation<double> sizeTween;

  int animationDuration = 500;

  bool isDone = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
    );
    _initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Test'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _SomethingRow(
                      color: colorTween.value,
                      child: _AnimatedCheckButton(
                        isCompleted: isDone,
                        tweenValue: sizeTween.value,
                        onPressed: () {
                          _animate();
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _animate();
      }),
    );
  }

  void _initAnimation() {
    colorTween = ColorTween(
      begin: Colors.white,
      end: const Color(0xffE6FCE0),
    ).animate(
      CurvedAnimation(
        parent: _animationController.view,
        curve: const Interval(0.0, 0.3),
      ),
    );
    sizeTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController.view,
        curve: Curves.ease,
      ),
    );
  }

  void _animate() {
    if (isDone) {
      setState(() {
        isDone = false;
      });
      _animationController.reverse();
    } else {
      setState(() {
        isDone = true;
      });
      _animationController.forward();
    }
  }
}

class _AnimatedCheckButton extends StatelessWidget {
  const _AnimatedCheckButton({
    super.key,
    required this.tweenValue,
    required this.isCompleted,
    this.onPressed,
  });
  final double tweenValue;
  final bool isCompleted;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: -0.2 * sin(2 * pi * tweenValue) + 1,
      child: CheckButton(isCompleted: isCompleted, onPressed: onPressed),
    );
  }
}

class _SomethingRow extends StatelessWidget {
  const _SomethingRow({
    super.key,
    this.color,
    this.child,
  });
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 50,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('I AM IRON MAN'),
            child ?? Container(),
          ],
        ),
      ),
    );
  }
}
