import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/hour_minute.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule_unit.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column_style.dart';
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
}
