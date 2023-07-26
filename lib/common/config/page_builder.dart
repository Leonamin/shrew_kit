import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page Function(BuildContext, GoRouterState) cubeTransitionPageBuilder(
  Widget fromChild,
  Widget toChild,
) {
  return (context, state) {
    return CustomTransitionPage(
      child: toChild,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                  child: fromChild,
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
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  };
}
