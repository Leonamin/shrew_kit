import 'package:flutter/material.dart';
import 'package:shrew_kit/component/daily_schedule_style.dart';
import 'package:shrew_kit/component/hour_minute.dart';
import 'package:shrew_kit/component/schedule_unit.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

class DailyScheduleView extends StatefulWidget {
  DailyScheduleView({
    super.key,
    this.style = const DailyScheduleStyle.defaultStyle(),
    required DateTime date,
    this.minimumTime = HourMinute.min,
    this.maximumTime = HourMinute.max,
  }) : date = date.withStartTime();
  final DailyScheduleStyle style;
  final DateTime date;
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
    Widget gesture = Positioned.fill(
        child: GestureDetector(
      onTapUp: (details) {
        DateTime timeTapped = widget.date
            .add(calculateOffsetToHourMinute(details.localPosition).asDuration);
        print(timeTapped);
        // TODO : 이벤트 호출 하기
      },
      child: Container(
        color: Colors.transparent,
      ),
    ));

    Widget mainWidget = SizedBox(
      height: calculateHeight(),
      child: Stack(children: [
        // add Background
        // add Gesture
        gesture
        // add Events
        // add hovering event
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

  double calculateTopOffset(
    HourMinute time, {
    HourMinute? minimumTime,
    double? unitRowHeight,
  }) =>
      defaultTopOffsetCalculator(
        time,
        minimumTime: minimumTime ?? widget.minimumTime,
        unitRowHeight: unitRowHeight ?? widget.style.unitRowHeight,
        unit: widget.style.unit,
      );

  HourMinute calculateOffsetToHourMinute(Offset localOffset) {
    double unitRowHeight = widget.style.unitRowHeight;
    double calcMinute =
        localOffset.dy * widget.style.unit.minute / unitRowHeight;

    if (calcMinute < 0) {
      return widget.minimumTime;
    }

    int hour = calcMinute ~/ 60;
    int minute = (calcMinute % 60).round();
    return widget.minimumTime.add(HourMinute(hour: hour, minute: minute));
  }

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
