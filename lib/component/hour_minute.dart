import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

class NowDateTimeGetter {
  DateTime now() => DateTime.now();
}

NowDateTimeGetter dateTimeGetter = NowDateTimeGetter();

class HourMinute {
  /// 최소 시간
  static const HourMinute zero = HourMinute._internal(hour: 0, minute: 0);

  /// 최소 시간
  static const HourMinute min = zero;

  /// 최대 시간.
  static const HourMinute max = HourMinute._internal(hour: 24, minute: 0);

  /// 시간
  final int hour;

  /// 분
  final int minute;

  const HourMinute._internal({
    required this.hour,
    required this.minute,
  });

  const HourMinute({
    int hour = 0,
    int minute = 0,
  }) : this._internal(
          hour: hour < 0 ? 0 : (hour > 23 ? 23 : hour),
          minute: minute < 0 ? 0 : (minute > 59 ? 59 : minute),
        );

  factory HourMinute.fromMinutes(int totalMinutes) {
    int hour = totalMinutes ~/ 60;
    int minute = totalMinutes % 60;
    return HourMinute._internal(hour: hour, minute: minute);
  }

  HourMinute.fromDateTime({
    required DateTime dateTime,
  }) : this._internal(hour: dateTime.hour, minute: dateTime.minute);

  HourMinute.fromTimeOfDay({
    required TimeOfDay timeOfDay,
  }) : this._internal(hour: timeOfDay.hour, minute: timeOfDay.minute);

  factory HourMinute.fromDuration({
    required Duration duration,
  }) {
    final totalMinutes = duration.inMinutes;
    return HourMinute.fromMinutes(totalMinutes);
  }

  HourMinute.now() : this.fromDateTime(dateTime: dateTimeGetter.now());

  HourMinute add(HourMinute other) {
    int totalMinutes = (hour + other.hour) * 60 + (minute + other.minute);
    return HourMinute.fromMinutes(totalMinutes);
  }

  HourMinute subtract(HourMinute other) {
    int totalMinutesThis = hour * 60 + minute;
    int totalMinutesOther = other.hour * 60 + other.minute;
    int totalMinutesResult = totalMinutesThis - totalMinutesOther;

    if (totalMinutesResult < 0) {
      return HourMinute.zero;
    }
    return HourMinute.fromMinutes(totalMinutesResult);
  }

  @override
  String toString() => jsonEncode({'hour': hour, 'minute': minute});

  @override
  bool operator ==(other) {
    if (other is! HourMinute) {
      return false;
    }
    return identical(this, other) ||
        (hour == other.hour && minute == other.minute);
  }

  bool operator <(other) {
    if (other is! HourMinute) {
      return false;
    }

    return _calculateDifference(other) < 0;
  }

  bool operator <=(other) {
    if (other is! HourMinute) {
      return false;
    }
    return _calculateDifference(other) <= 0;
  }

  bool operator >(other) {
    if (other is! HourMinute) {
      return false;
    }
    return _calculateDifference(other) > 0;
  }

  bool operator >=(other) {
    if (other is! HourMinute) {
      return false;
    }
    return _calculateDifference(other) >= 0;
  }

  DateTime atDate(DateTime date) => date
      .of(year: date.year, month: date.month, day: date.day)
      .add(asDuration);

  Duration get asDuration => Duration(hours: hour, minutes: minute);

  @override
  int get hashCode => hour.hashCode + minute.hashCode;

  int _calculateDifference(HourMinute other) =>
      (hour * 60 - other.hour * 60) + (minute - other.minute);
}
