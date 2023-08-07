import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_view.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

typedef EventTextBuilder = Widget Function(
  Schedule event,
  BuildContext context,
  DailyScheduleView dayView,
  double height,
  double width,
);

class Schedule<T> extends Comparable<Schedule> {
  final String title;
  final String description;
  DateTime start;
  DateTime end;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EventTextBuilder? eventTextBuilder;

  Schedule({
    required this.title,
    required this.description,
    required DateTime start,
    required DateTime end,
    this.backgroundColor = const Color(0xCC2196F3),
    this.decoration,
    this.textStyle = const TextStyle(color: Colors.white),
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.onTap,
    this.onLongPress,
    this.eventTextBuilder,
  })  : start = start.of(second: 0),
        end = end.of(second: 0);

  Widget build(
    BuildContext context,
    DailyScheduleView dayView,
    double height,
    double width,
  ) {
    height = height - (padding?.top ?? 0.0) - (padding?.bottom ?? 0.0);
    width = width - (padding?.left ?? 0.0) - (padding?.right ?? 0.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Ink(
          decoration: decoration ??
              (backgroundColor != null
                  ? BoxDecoration(color: backgroundColor)
                  : null),
          child: Container(
            margin: margin,
            padding: padding,
            child: eventTextBuilder?.call(
                  this,
                  context,
                  dayView,
                  math.max(0.0, height),
                  math.max(0.0, width),
                ) ??
                Container(),
          ),
        ),
      ),
    );
  }

  /// Shifts the start and end times, so that the event's duration is unaltered
  /// and the event now starts in [newStartTime].
  void shiftEventTo(DateTime newStartTime) {
    end = end.add(newStartTime.difference(start));
    start = newStartTime;
  }

  @override
  int compareTo(Schedule other) {
    int result = start.compareTo(other.start);
    if (result != 0) {
      return result;
    }
    return end.compareTo(other.end);
  }
}
