import 'package:flutter/material.dart';
import 'package:shrew_kit/component/daily_schedule_style.dart';
import 'package:shrew_kit/component/hour_minute.dart';
import 'package:shrew_kit/component/schedule_unit.dart';

class DailyScheduleView extends StatefulWidget {
  const DailyScheduleView({
    super.key,
    this.style = const DailyScheduleStyle.defaultStyle(),
    this.minimumTime = HourMinute.min,
    this.maximumTime = HourMinute.max,
  });
  final DailyScheduleStyle style;
  final HourMinute minimumTime;
  final HourMinute maximumTime;

  @override
  State<DailyScheduleView> createState() => _DailyScheduleViewState();
}

class _DailyScheduleViewState extends State<DailyScheduleView> {
  @override
  Widget build(BuildContext context) {
    var mainWidget = createMainWidget();
    return mainWidget;
  }

  // 위젯 관련
  Widget createMainWidget() {
    Widget mainWidget = SizedBox(
      height: calculateHeight(),
      child: Stack(children: [
        // add Background
        // add Events
      ]),
    );

    mainWidget = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: mainWidget,
    );

    return mainWidget;
  }

  // 계산 관련
  double calculateHeight([double? unitRowHeight]) =>
      calculateTopOffset(widget.maximumTime, unitRowHeight: unitRowHeight);

  double calculateTopOffset(HourMinute time,
          {HourMinute? minimumTime, double? unitRowHeight}) =>
      defaultTopOffsetCalculator(
        time,
        minimumTime: minimumTime ?? widget.minimumTime,
        unitRowHeight: unitRowHeight ?? widget.style.unitRowHeight,
        unit: widget.style.unit,
      );

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
}
