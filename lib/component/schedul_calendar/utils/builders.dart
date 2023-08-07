import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/hour_minute.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule_unit.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column_style.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/uitls.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

class DefaultBuilders {
  /// Formats a hour in 24-hour HH:MM format, e.g., 15:00.
  static String defaultTimeFormatter(HourMinute time) =>
      time.toDateTime().toHM();

  // 전역 유틸
  static double defaultTopOffsetCalculator(
    HourMinute time, {
    HourMinute minimumTime = HourMinute.min,
    ScheduleUnit unit = ScheduleUnit.min30,
    double unitRowHeight = 60,
  }) {
    HourMinute relative = time.subtract(minimumTime);
    final totalMunutes = relative.hour * 60 + relative.minute;
    return totalMunutes / unit.minute * unitRowHeight;
  }

  static Widget defaultUnitColumnTimeBuilder(
      UnitColumnStyle unitColumnStyle, HourMinute time) {
    return Text(
      unitColumnStyle.timeFormatter(time),
      style: unitColumnStyle.textStyle,
    );
  }

  static bool? _exceedHeight(
      List<TextSpan> input, TextStyle? textStyle, double height, double width) {
    double fontSize = textStyle?.fontSize ?? 14;
    int maxLines = height ~/ ((textStyle?.height ?? 1.2) * fontSize);
    if (maxLines == 0) {
      return null;
    }

    TextPainter painter = TextPainter(
      text: TextSpan(
        children: input,
        style: textStyle,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: width);
    return painter.didExceedMaxLines;
  }

  static bool _ellipsize(List<TextSpan> input, [String ellipse = '…']) {
    if (input.isEmpty) {
      return false;
    }

    TextSpan last = input.last;
    String? text = last.text;
    if (text == null || text.isEmpty || text == ellipse) {
      input.removeLast();

      if (text == ellipse) {
        _ellipsize(input, ellipse);
      }
      return true;
    }

    String truncatedText;
    if (text.endsWith('\n')) {
      truncatedText = text.substring(0, text.length - 1) + ellipse;
    } else {
      truncatedText = Utils.removeLastWord(text);
      truncatedText =
          truncatedText.substring(0, math.max(0, truncatedText.length - 2)) +
              ellipse;
    }

    input[input.length - 1] = TextSpan(
      text: truncatedText,
      style: last.style,
    );

    return true;
  }
}
