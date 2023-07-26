import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/view/animated_list/test_animdated_list_view.dart';
import 'package:shrew_kit/view/anime/animation_test.dart';
import 'package:shrew_kit/view/concentric/concentric_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_hamster_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_shrew_view.dart';
import 'package:shrew_kit/view/home/home_view.dart';
import 'package:shrew_kit/view/jump_page/jump_page_view.dart';
import 'package:shrew_kit/view/neo/neo_view.dart';
import 'package:shrew_kit/view/transition/fadeinout/fadeinout_view.dart';

final router = GoRouter(
  initialLocation: ShrewRoutes.home.path,
  routes: [
    GoRoute(
      path: ShrewRoutes.home.path,
      name: ShrewRoutes.home.name,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: ShrewRoutes.jumpPageView.path,
          name: ShrewRoutes.jumpPageView.name,
          builder: (context, state) => const JumpPageView(),
        ),
        GoRoute(
          path: ShrewRoutes.testAnimatedListView.path,
          name: ShrewRoutes.testAnimatedListView.name,
          builder: (context, state) => const TestAnimatedListView(),
        ),
        GoRoute(
          path: ShrewRoutes.cubeHamsterView.path,
          name: ShrewRoutes.cubeHamsterView.name,
          builder: (context, state) => const CubeHamsterView(),
          routes: [
            GoRoute(
              path: ShrewRoutes.cubeShrewView.path,
              name: ShrewRoutes.cubeShrewView.name,
              builder: (context, state) => const CubeShrewView(),
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const CubeShrewView(),
                transitionsBuilder:
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
                            child: CubeHamsterView(),
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
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        GoRoute(
          path: ShrewRoutes.neo.path,
          name: ShrewRoutes.neo.name,
          builder: (context, state) => const NeoView(),
        ),
        GoRoute(
          path: ShrewRoutes.concentric.path,
          name: ShrewRoutes.concentric.name,
          builder: (context, state) => const ConcentricView(),
        ),
        GoRoute(
          path: ShrewRoutes.fadeInOut.path,
          name: ShrewRoutes.fadeInOut.name,
          builder: (context, state) => const FadeInOutView(),
        ),
        GoRoute(
          path: ShrewRoutes.testAnimation.path,
          name: ShrewRoutes.testAnimation.name,
          builder: (context, state) => const AnimationTest(),
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);

// Widget cubeTransition(context, animation, secondaryAnimation, child) {
//   var pi;
//   return Stack(
//     children: <Widget>[
//       SlideTransition(
//         position: Tween<Offset>(
//           begin: Offset.zero,
//           end: const Offset(-1.0, 0.0),
//         ).animate(animation),
//         child: Container(
//           color: Colors.white,
//           child: Transform(
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.003)
//               ..rotateY(pi / 2 * animation.value),
//             alignment: FractionalOffset.centerRight,
//             child: exitPage,
//           ),
//         ),
//       ),
//       SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(1.0, 0.0),
//           end: Offset.zero,
//         ).animate(animation),
//         child: Container(
//           color: Colors.white,
//           child: Transform(
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.003)
//               ..rotateY(pi / 2 * (animation.value - 1)),
//             alignment: FractionalOffset.centerLeft,
//             child: enterPage,
//           ),
//         ),
//       )
//     ],
//   );
// }
