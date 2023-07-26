import 'package:flutter/material.dart';

class WidgetUtil {
  WidgetUtil._();

  static double getTextWidth({
    required String text,
    required TextStyle style,
  }) {
    final textSpan = TextSpan(text: text, style: style);

    final tp = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return tp.size.width;
  }

  static double getTextHeight({
    required String text,
    required TextStyle style,
    required double screenWidth,
  }) {
    if (text.isEmpty) return 0;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    int numberOfLine = textPainter.width ~/ screenWidth;

    return textPainter.height * (numberOfLine + 1);
  }
}
