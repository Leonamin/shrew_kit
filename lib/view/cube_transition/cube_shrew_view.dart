import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/constants/asset_constants.dart';

class CubeShrewView extends StatelessWidget {
  const CubeShrewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => onTapMain(context),
        child: const Center(
          child: Image(
            image: AssetImage(AssetConstant.shrewHomeImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void onTapMain(BuildContext context) {
    context.pop();
    // Navigator.of(context).pushAndRemoveUntil(
    //     CubePageRoute(
    //       const CubeShrewView(),
    //       const HamsterHomeView(),
    //     ),
    //     (route) {
    //       return false;
    //     },
    //   );
  }
}
