import 'package:flutter/material.dart';
import 'package:shrew_kit/component/builders.dart';
import 'package:shrew_kit/component/hour_minute.dart';
import 'package:shrew_kit/component/typedefs.dart';
import 'package:shrew_kit/component/unit_column_style.dart';

/// A column which is showing a day hours.
class UnitColumn extends StatelessWidget {
  /// The minimum time to display.
  final HourMinute minimumTime;

  /// The maximum time to display.
  final HourMinute maximumTime;

  /// The top offset calculator.
  final TopOffsetCalculator topOffsetCalculator;

  /// The widget style.
  final UnitColumnStyle style;

  /// Triggered when the hours column has been tapped down.
  final UnitColumnTapCallback? onUnitColumnTappedDown;

  /// The times to display on the side border.
  final List<HourMinute> _sideTimes;

  /// Building method for building the time displayed on the side border.
  final UnitColumnTimeBuilder unitColumnTimeBuilder;

  /// Building method for building background decoration below single time displayed on the side border.
  final UnitColumnBackgroundBuilder? unitColumnBackgroundBuilder;

  /// Creates a new hours column instance.
  UnitColumn({
    super.key,
    this.minimumTime = HourMinute.min,
    this.maximumTime = HourMinute.max,
    TopOffsetCalculator? topOffsetCalculator,
    this.style = const UnitColumnStyle(),
    this.onUnitColumnTappedDown,
    UnitColumnTimeBuilder? unitColumnTimeBuilder,
    this.unitColumnBackgroundBuilder,
  })  : assert(minimumTime < maximumTime),
        topOffsetCalculator =
            topOffsetCalculator ?? DefaultBuilders.defaultTopOffsetCalculator,
        unitColumnTimeBuilder = unitColumnTimeBuilder ??
            DefaultBuilders.defaultUnitColumnTimeBuilder,
        _sideTimes = getSideTimes(minimumTime, maximumTime, style.interval);

  @override
  Widget build(BuildContext context) {
    final singleHourSize =
        topOffsetCalculator(maximumTime) / (maximumTime.hour);
    final Widget background;
    if (unitColumnBackgroundBuilder != null) {
      background = SizedBox(
        height: topOffsetCalculator(maximumTime),
        width: style.width,
        child: Padding(
          padding: EdgeInsets.only(top: singleHourSize),
          child: Column(
            children: _sideTimes
                .map(
                  (time) => Container(
                    decoration: unitColumnBackgroundBuilder!(time),
                    height: singleHourSize,
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      background = const SizedBox.shrink();
    }

    Widget child = Container(
      height: topOffsetCalculator(maximumTime),
      width: style.width,
      color: style.decoration == null ? style.color : null,
      decoration: style.decoration,
      child: Stack(
        children: <Widget>[background] +
            _sideTimes
                .map(
                  (time) => Positioned(
                    top: topOffsetCalculator(time) -
                        ((style.textStyle.fontSize ?? 14) / 2),
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: style.textAlignment,
                      child: unitColumnTimeBuilder(style, time),
                    ),
                  ),
                )
                .toList(),
      ),
    );

    if (onUnitColumnTappedDown == null) {
      return child;
    }

    return GestureDetector(
      onTapDown: (details) {
        var hourRowHeight =
            topOffsetCalculator(minimumTime.add(const HourMinute(hour: 1)));
        double hourMinutesInHour = details.localPosition.dy / hourRowHeight;

        int hour = hourMinutesInHour.floor();
        int minute = ((hourMinutesInHour - hour) * 60).round();
        onUnitColumnTappedDown!(
            minimumTime.add(HourMinute(hour: hour, minute: minute)));
      },
      child: child,
    );
  }

  /// 일정 끝 시간을 기준으로 리스트 생성
  static List<HourMinute> getSideTimes(
      HourMinute minimumTime, HourMinute maximumTime, Duration interval) {
    List<HourMinute> sideTimes = [];
    HourMinute currentTime =
        minimumTime.add(HourMinute.fromDuration(duration: interval));
    while (currentTime < maximumTime) {
      sideTimes.add(currentTime);
      currentTime =
          currentTime.add(HourMinute.fromDuration(duration: interval));
    }
    return sideTimes;
  }
}
