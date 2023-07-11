import 'package:flutter/material.dart';

class FadeInOutView extends StatefulWidget {
  const FadeInOutView({super.key});

  @override
  State<FadeInOutView> createState() => _FadeInOutViewState();
}

class _FadeInOutViewState extends State<FadeInOutView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool isPlayingAnimation = false;
  String userName = 'A';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.cyan,
            child: Center(
              child: Column(
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 100),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onTap();
                    },
                    child: const Text('FadeInOut'),
                  ),
                ],
              ),
            ),
          ),
          (isPlayingAnimation)
              ? FadeInFadeOutTransition(controller: _controller)
              : Container(),
        ],
      ),
    );
  }

  void changeUser() {
    if (userName == 'A') {
      userName = 'B';
    } else {
      userName = 'A';
    }
    setState(() {});
  }

  void onTap() async {
    setState(() {
      isPlayingAnimation = !isPlayingAnimation;
    });
    _controller.forward().then((value) async {
      changeUser();
      await Future.delayed(Duration(milliseconds: 500));
      _controller.reverse().then((value) {
        setState(() {
          isPlayingAnimation = !isPlayingAnimation;
        });
      });
    });
  }
}

class FadeInFadeOutTransition extends StatelessWidget {
  const FadeInFadeOutTransition({super.key, required this.controller});
  final AnimationController controller;

  double get opacity => controller.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          color: Colors.white.withOpacity(controller.value),
        );
      },
    );
  }
}
