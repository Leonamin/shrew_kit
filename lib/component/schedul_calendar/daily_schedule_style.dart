import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_view.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/hour_minute.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule_unit.dart';
import 'package:shrew_kit/component/schedul_calendar/typedefs.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column.dart';

class DailyScheduleStyle {
  final ScheduleUnit unit;
  final double unitRowHeight;
  final Color? backgroundColor;
  final Color? backgroundRulesColor;

  //  unit 당 기본 높이
  //  unit이 5분이고 기본 높이가 50이면 5분당 50픽셀, 1시간당 600픽셀

  const DailyScheduleStyle({
    ScheduleUnit? unit,
    double? unitRowHeight,
    this.backgroundColor,
    this.backgroundRulesColor = Colors.grey,
  })  : unit = unit ?? ScheduleUnit.min30,
        unitRowHeight = unitRowHeight ?? 50;

  const DailyScheduleStyle.defaultStyle()
      : this(
          unit: ScheduleUnit.min30,
          unitRowHeight: 50,
        );

  CustomPainter createBackgroundPainter({
    required DailyScheduleView view,
    required TopOffsetCalculator topOffsetCalculator,
  }) =>
      _EventsColumnBackgroundPainter(
        minimumTime: view.minimumTime,
        maximumTime: view.maximumTime,
        topOffsetCalculator: topOffsetCalculator,
        dayViewStyle: this,
        interval: view.style.unit.duration,
      );
}

/// The events column background painter.
class _EventsColumnBackgroundPainter extends CustomPainter {
  /// The minimum time to display.
  final HourMinute minimumTime;

  /// The maximum time to display.
  final HourMinute maximumTime;

  /// The top offset calculator.
  final TopOffsetCalculator topOffsetCalculator;

  /// The day view style.
  final DailyScheduleStyle dayViewStyle;

  /// The interval between two lines.
  final Duration interval;

  /// Creates a new events column background painter.
  const _EventsColumnBackgroundPainter({
    required this.minimumTime,
    required this.maximumTime,
    required this.topOffsetCalculator,
    required this.dayViewStyle,
    required this.interval,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dayViewStyle.backgroundColor != null) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = dayViewStyle.backgroundColor!);
    }

    if (dayViewStyle.backgroundRulesColor != null) {
      final List<HourMinute> sideTimes =
          UnitColumn.getSideTimes(minimumTime, maximumTime, interval);
      for (HourMinute time in sideTimes) {
        double topOffset = topOffsetCalculator(time);
        canvas.drawLine(Offset(0, topOffset), Offset(size.width, topOffset),
            Paint()..color = dayViewStyle.backgroundRulesColor!);
      }
    }
  }

  @override
  bool shouldRepaint(
      _EventsColumnBackgroundPainter oldDayViewBackgroundPainter) {
    return dayViewStyle.backgroundColor !=
            oldDayViewBackgroundPainter.dayViewStyle.backgroundColor ||
        dayViewStyle.backgroundRulesColor !=
            oldDayViewBackgroundPainter.dayViewStyle.backgroundRulesColor ||
        topOffsetCalculator != oldDayViewBackgroundPainter.topOffsetCalculator;
  }
}
