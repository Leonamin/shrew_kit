import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({
    super.key,
    required this.isCompleted,
    this.width,
    this.height,
    this.onPressed,
  });
  final bool isCompleted;
  final double? width;
  final double? height;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: width ?? 34,
        height: height ?? 24,
        child: isCompleted
            ? SvgPicture.asset(
                'assets/svgs/icons/icon - todo - checked.svg',
                fit: BoxFit.contain,
              )
            : SvgPicture.asset(
                'assets/svgs/icons/icon - todo - unchecked.svg',
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
