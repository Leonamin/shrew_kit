import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _RouteTile(
              text: 'JumpPageView',
              onTap: () {
                context.goNamed(ShrewRoutes.jumpPageView.name);
              },
            ),
            _RouteTile(
              text: 'TestAnimatedListView',
              onTap: () {
                context.goNamed(ShrewRoutes.testAnimatedListView.name);
              },
            ),
            _RouteTile(
              text: 'Hamster',
              onTap: () {
                context.goNamed(ShrewRoutes.cubeHamsterView.name);
              },
            ),
            _RouteTile(
              text: 'Neo',
              onTap: () {
                context.goNamed(ShrewRoutes.neo.name);
              },
            ),
            _RouteTile(
              text: 'Concentric',
              onTap: () {
                context.goNamed(ShrewRoutes.concentric.name);
              },
            ),
            _RouteTile(
              text: 'FadeInOut',
              onTap: () {
                context.goNamed(ShrewRoutes.fadeInOut.name);
              },
            ),
            _RouteTile(
              text: 'AnimationTest',
              onTap: () {
                context.goNamed(ShrewRoutes.testAnimation.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteTile extends StatelessWidget {
  const _RouteTile({
    Key? key,
    required this.text,
    this.onTap,
    this.padding,
    this.color,
    this.textColor,
  }) : super(key: key);

  final String text;
  final Function()? onTap;
  final EdgeInsets? padding;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: 60, minWidth: double.infinity),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? const Color(0xFFFAFAFA),
                boxShadow: const [
                  BoxShadow(blurRadius: 1, color: Colors.black12),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor ?? const Color(0xFF333333),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: textColor ?? const Color(0xFF333333),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
