import 'dart:math';

import 'package:flutter/material.dart';

class SliderThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final String label;
  final Color color;

  const SliderThumbShape({
    this.thumbRadius = 15.0,
    this.label = '',
    this.color = kDefaultIconLightColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Draw thumb circle
    canvas.drawCircle(
      center,
      thumbRadius,
      Paint()..color = sliderTheme.thumbColor!,
    );

    const icon = Icons.menu;
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 24.0,
          fontFamily: icon.fontFamily,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();

    const angle = 90 * pi / 180;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    iconPainter.paint(
        canvas, Offset(-iconPainter.width / 2, -iconPainter.height / 2));
    canvas.restore();
  }
}
