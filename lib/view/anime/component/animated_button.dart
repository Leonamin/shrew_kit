import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedToggleButton extends StatefulWidget {
  const AnimatedToggleButton({
    super.key,
    required this.on,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });
  final Widget child;
  final bool on;
  final Duration duration;

  @override
  State<AnimatedToggleButton> createState() => _AnimatedToggleButtonState();
}

class _AnimatedToggleButtonState extends State<AnimatedToggleButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: widget.on ? Colors.red : Colors.blue,
        borderRadius:
            widget.on ? BorderRadius.circular(100) : BorderRadius.circular(100),
      ),
      width: widget.on ? 100.0 : 200.0,
      height: widget.on ? 100.0 : 50.0,
      alignment: widget.on ? Alignment.center : AlignmentDirectional.topCenter,
      duration: widget.duration,
      curve: Curves.fastOutSlowIn,
      child: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedRotation(
                turns: pi * (widget.on ? 0 : 45),
                duration: widget.duration,
                child: AnimatedOpacity(
                  opacity: widget.on ? 1 : 0,
                  duration: widget.duration,
                  child: Icon(Icons.close),
                ),
              ),
            ),
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: widget.on ? 0 : 1,
                    duration: widget.duration,
                    child: Icon(Icons.add),
                  ),
                  AnimatedOpacity(
                    opacity: widget.on ? 0 : 1,
                    duration: widget.duration,
                    child: Text('기록하기'),
                  ),
                ],
              ),
            )

            // if (widget.on)
            //   AnimatedRotation(
            //     turns: pi * (widget.on ? 0 : 180),
            //     duration: const Duration(seconds: 1),
            //     child: Icon(Icons.close),
            //   ),
            // if (!widget.on) ...[
            //   Icon(Icons.add),
            //   Text('기록하기'),
            // ]
          ],
        ),
      ),
    );
    // return AnimatedContainer(
    //   duration: Duration(milliseconds: 500),
    //   color: widget.on ? Colors.white : Colors.black,
    //   child: widget.child,
    // );
  }
}
