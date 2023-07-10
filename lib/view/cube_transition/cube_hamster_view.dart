import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/common/constants/asset_constants.dart';
import 'package:shrew_kit/view/cube_transition/component/cube_route_builder.dart';
import 'package:shrew_kit/view/cube_transition/cube_shrew_view.dart';

class CubeHamsterView extends StatelessWidget {
  const CubeHamsterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => onTapMain(context),
        child: const Image(
          image: AssetImage(AssetConstant.hamsterHomeImage),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  void onTapMain(BuildContext context) {
    context.go(ViewRoutes.cubeShrewViewRoute, extra: {
      'routeBuilder': CubePageRoute(
        this,
        const CubeShrewView(),
      ),
    });
  }
}
