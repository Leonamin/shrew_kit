import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/common/config/page_builder.dart';
import 'package:shrew_kit/view/animated_list/test_animdated_list_view.dart';
import 'package:shrew_kit/view/anime/animation_test.dart';
import 'package:shrew_kit/view/color_chart/color_chart_view.dart';
import 'package:shrew_kit/view/concentric/concentric_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_hamster_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_shrew_view.dart';
import 'package:shrew_kit/view/home/home_view.dart';
import 'package:shrew_kit/view/jump_page/jump_page_view.dart';
import 'package:shrew_kit/view/neo/neo_view.dart';
import 'package:shrew_kit/view/slider/test_slider_view.dart';
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
              pageBuilder: cubeTransitionPageBuilder(
                const CubeHamsterView(),
                const CubeShrewView(),
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
        GoRoute(
          path: ShrewRoutes.testSlider.path,
          name: ShrewRoutes.testSlider.name,
          builder: (context, state) => TestSliderView(),
        ),
        GoRoute(
          path: ShrewRoutes.colorChart.path,
          name: ShrewRoutes.colorChart.name,
          builder: (context, state) => const ColorChartView(),
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
