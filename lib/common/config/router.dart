import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/view/animated_list/test_animdated_list_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_hamster_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_shrew_view.dart';
import 'package:shrew_kit/view/home/home_view.dart';
import 'package:shrew_kit/view/jump_page/jump_page_view.dart';
import 'package:shrew_kit/view/neo/neo_view.dart';

final router = GoRouter(
  initialLocation: ViewRoutes.homePath,
  routes: [
    GoRoute(
      path: ViewRoutes.homePath,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: ViewRoutes.jumpPageViewPath,
          builder: (context, state) => const JumpPageView(),
        ),
        GoRoute(
          path: ViewRoutes.testAnimatedListViewPath,
          builder: (context, state) => const TestAnimatedListView(),
        ),
        GoRoute(
          path: ViewRoutes.cubeHamsterViewPath,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: CubeHamsterView(),
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
                        child: child,
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
          builder: (context, state) => const CubeHamsterView(),
          routes: [
            GoRoute(
              path: ViewRoutes.cubeShrewViewPath,
              builder: (context, state) => const CubeShrewView(),
            ),
          ],
        ),
        GoRoute(
          path: ViewRoutes.neoPath,
          builder: (context, state) => const NeoView(),
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
