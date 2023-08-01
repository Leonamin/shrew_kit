import 'package:flutter/material.dart';
import 'package:shrew_kit/component/daily_schedule_style.dart';
import 'package:shrew_kit/component/hour_minute.dart';
import 'package:shrew_kit/component/unit_column_style.dart';

typedef DateFormatter = String Function(int year, int month, int day);

typedef TimeFormatter = String Function(HourMinute time);

typedef TopOffsetCalculator = double Function(HourMinute time);

/// Triggered when the hours column has been tapped down.
typedef UnitColumnTapCallback = Function(HourMinute time);

/// Triggered when the day bar has been tapped down.
typedef DayBarTapCallback = Function(DateTime date);

/// Triggered when there's a click on the background (an empty region of the calendar). The returned
/// value corresponds to the hour/minute where the user made the tap. For better user experience,
/// you may want to round this value using [roundTimeToFitGrid].
typedef BackgroundTapCallback = Function(DateTime date);

/// Allows to build the current time indicator (rule and circle).
typedef CurrentTimeIndicatorBuilder = Widget? Function(
    DailyScheduleStyle viewStyle,
    TopOffsetCalculator topOffsetCalculator,
    double unitColumnWidth,
    bool isRtl);

/// Allows to build the time displayed on the side border.
typedef UnitColumnTimeBuilder = Widget? Function(
    UnitColumnStyle unitViewStyle, HourMinute time);

/// Allows to build the background decoration below single time displayed on the side border.
typedef UnitColumnBackgroundBuilder = Decoration? Function(HourMinute time);
