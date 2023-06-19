import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/test_animdated_list_view.dart';
import 'package:shrew_kit/view/home/home_view.dart';
import 'package:shrew_kit/view/jump_page_view.dart';

final router = GoRouter(
  initialLocation: ViewRoutes.homePath,
  routes: [
    GoRoute(
      path: ViewRoutes.homePath,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
            path: ViewRoutes.jumpPageViewPath,
            builder: (context, state) => const JumpPageView()),
        GoRoute(
            path: ViewRoutes.testAnimatedListViewPath,
            builder: (context, state) => const TestAnimatedListView()),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
