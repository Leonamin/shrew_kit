import 'dart:math';

import 'package:flutter/material.dart';

class CubePageRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  final Duration? duration;
  CubePageRoute(
    this.exitPage,
    this.enterPage, {
    this.duration,
  }) : super(
            pageBuilder: (context, animation, secondaryAnimation) => enterPage,
            transitionsBuilder: _transitionsBuilder(exitPage, enterPage),
            transitionDuration: duration ?? const Duration(milliseconds: 300));

  static _transitionsBuilder(exitPage, enterPage) =>
      (context, animation, secondaryAnimation, child) {
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-1.0, 0.0),
              ).animate(animation),
              child: Container(
                color: Colors.white,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateY(pi / 2 * animation.value),
                  alignment: FractionalOffset.centerRight,
                  child: exitPage,
                ),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: Container(
                color: Colors.white,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateY(pi / 2 * (animation.value - 1)),
                  alignment: FractionalOffset.centerLeft,
                  child: enterPage,
                ),
              ),
            )
          ],
        );
      };
}
