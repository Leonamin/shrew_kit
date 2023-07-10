import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/view/animated_list/test_animdated_list_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_hamster_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_shrew_view.dart';
import 'package:shrew_kit/view/home/home_view.dart';
import 'package:shrew_kit/view/jump_page/jump_page_view.dart';

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
          builder: (context, state) => const CubeHamsterView(),
          routes: [
            GoRoute(
              path: ViewRoutes.cubeShrewViewPath,
              builder: (context, state) => const CubeShrewView(),
            ),
          ],
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
