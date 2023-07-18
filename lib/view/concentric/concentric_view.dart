import 'package:flutter/material.dart';
import 'package:shrew_kit/view/concentric/clipper.dart';

class ConcentricView extends StatefulWidget {
  const ConcentricView({super.key});

  @override
  State<ConcentricView> createState() => _ConcentricViewState();
}

class _ConcentricViewState extends State<ConcentricView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isForward = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipPath(
          clipper: ConcentricClipper(progress: _controller.value),
          child: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Colors.cyan, shape: BoxShape.circle),
                    ),
                    onTap: () {
                      if (isForward) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                      setState(() {
                        isForward = !isForward;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
