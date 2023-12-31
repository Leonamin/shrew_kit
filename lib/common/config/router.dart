import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/common/config/page_builder.dart';
import 'package:shrew_kit/view/animated_list/test_animdated_list_view.dart';
import 'package:shrew_kit/view/anime/animation_test.dart';
import 'package:shrew_kit/view/anime/expandable_fab_view.dart';
import 'package:shrew_kit/view/color_chart/color_chart_view.dart';
import 'package:shrew_kit/view/concentric/concentric_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_hamster_view.dart';
import 'package:shrew_kit/view/cube_transition/cube_shrew_view.dart';
import 'package:shrew_kit/view/home/home_view.dart';
import 'package:shrew_kit/view/jump_page/jump_page_view.dart';
import 'package:shrew_kit/view/neo/neo_view.dart';
import 'package:shrew_kit/view/scheduling/custom/add_schedule_view.dart';
import 'package:shrew_kit/view/scheduling/custom/calendar_algorithm_view.dart';
import 'package:shrew_kit/view/scheduling/custom/custom_scheduling_view.dart';
import 'package:shrew_kit/view/scheduling/libs/lib_calendar_day_view.dart';
import 'package:shrew_kit/view/scheduling/libs/lib_calendar_view.dart';
import 'package:shrew_kit/view/scheduling/libs/lib_flutter_week_view.dart';
import 'package:shrew_kit/view/scheduling/libs/lib_table_calendar_view.dart';
import 'package:shrew_kit/view/scheduling/scheduling_view.dart';
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
        GoRoute(
          path: ShrewRoutes.expandableFab.path,
          name: ShrewRoutes.expandableFab.name,
          builder: (context, state) => ExpandableFabView(),
        ),
        GoRoute(
          path: ShrewRoutes.scheduling.path,
          name: ShrewRoutes.scheduling.name,
          builder: (context, state) => const SchedulingView(),
          routes: [
            GoRoute(
                path: SchedulingRoutes.custom.path,
                name: SchedulingRoutes.custom.name,
                builder: (context, state) => const CustomSchedulingView(),
                routes: [
                  GoRoute(
                    path: CustomScheduleChildRoutes.addSchedule.path,
                    name: CustomScheduleChildRoutes.addSchedule.name,
                    builder: (context, state) => AddScheduleView(
                      dtStart: (state.extra! as Map)['dtStart'],
                      dtEnd: (state.extra! as Map)['dtEnd'],
                    ),
                  ),
                ]),
            GoRoute(
              path: SchedulingRoutes.calendarAlgorithm.path,
              name: SchedulingRoutes.calendarAlgorithm.name,
              builder: (context, state) => const CalendarAlgorithmView(),
            ),
            GoRoute(
              path: SchedulingRoutes.calendarDayView.path,
              name: SchedulingRoutes.calendarDayView.name,
              builder: (context, state) => const LibCalendarDayView(),
            ),
            GoRoute(
              path: SchedulingRoutes.calendarView.path,
              name: SchedulingRoutes.calendarView.name,
              builder: (context, state) => const LibCalendarView(),
            ),
            GoRoute(
              path: SchedulingRoutes.flutterWeekView.path,
              name: SchedulingRoutes.flutterWeekView.name,
              builder: (context, state) => const LibFlutterWeekView(),
            ),
            GoRoute(
              path: SchedulingRoutes.tableCalendar.path,
              name: SchedulingRoutes.tableCalendar.name,
              builder: (context, state) => const LibTableCalendarView(),
            ),
          ],
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
