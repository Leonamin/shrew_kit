import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_style.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/hour_minute.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column_style.dart';

typedef DateFormatter = String Function(int year, int month, int day);

typedef TimeFormatter = String Function(HourMinute time);

typedef TopOffsetCalculator = double Function(HourMinute time);

typedef UnitColumnTapCallback = Function(HourMinute time);

typedef DayBarTapCallback = Function(DateTime date);

typedef BackgroundTapCallback = Function(DateTime date);

typedef CurrentTimeIndicatorBuilder = Widget? Function(
    DailyScheduleStyle viewStyle,
    TopOffsetCalculator topOffsetCalculator,
    double unitColumnWidth,
    bool isRtl);

typedef UnitColumnTimeBuilder = Widget? Function(
    UnitColumnStyle unitViewStyle, HourMinute time);

typedef UnitColumnBackgroundBuilder = Decoration? Function(HourMinute time);

typedef HoverEndCallback = Function(DateTime date);
