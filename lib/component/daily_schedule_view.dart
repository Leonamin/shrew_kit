import 'package:flutter/material.dart';
import 'package:shrew_kit/component/builders.dart';
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
    this.onBackgroundTapped,
  }) : date = date.withStartTime();
  final DailyScheduleStyle style;
  final DateTime date;
  final HourMinute minimumTime;
  final HourMinute maximumTime;
  final Function(DateTime)? onBackgroundTapped;

  @override
  State<DailyScheduleView> createState() => _DailyScheduleViewState();
}

class _DailyScheduleViewState extends State<DailyScheduleView> {
  bool isDragging = false;
  double hoverPos = 0;

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
        DateTime timeTapped = widget.date.add(
            calculateOffsetToHourMinute(details.localPosition.dy).asDuration);
        widget.onBackgroundTapped?.call(timeTapped);
      },
      onLongPressStart: onPreviewStart,
      onLongPressMoveUpdate: onPreviewMoveUpdate,
      onLongPressEnd: onPrivewEnd,
      onLongPressCancel: onPreviewCancel,
      child: Container(
        color: Colors.transparent,
      ),
    ));

    Widget previewEvnet = Positioned(
      left: 0,
      right: 0,
      top: hoverPos,
      child: EventTile(
        height: widget.style.unitRowHeight,
      ),
    );

    Widget mainWidget = SizedBox(
      height: calculateHeight(),
      child: Stack(children: [
        // add Background
        createBackground(),
        // add Gesture
        gesture,
        // add Events
        // add hovering event
        if (isDragging) previewEvnet
      ]),
    );

    mainWidget = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: mainWidget,
    );

    return mainWidget;
  }

  Widget createBackground() => Positioned.fill(
        child: CustomPaint(
          painter: widget.style.createBackgroundPainter(
            view: widget,
            topOffsetCalculator: calculateTopOffset,
          ),
        ),
      );

  // 호버링 관련
  void onPreviewStart(LongPressStartDetails details) {
    isDragging = true;
    hoverPos = clampToOffsetByHourMinute(
        calculateOffsetToHourMinute(details.localPosition.dy));
    setState(() {});
  }

  void onPreviewMoveUpdate(LongPressMoveUpdateDetails details) {
    hoverPos = clampToOffsetByHourMinute(
        calculateOffsetToHourMinute(details.localPosition.dy));
    setState(() {});
  }

  void onPrivewEnd(LongPressEndDetails details) {
    isDragging = false;
    setState(() {});
  }

  void onPreviewCancel() {
    isDragging = false;
    setState(() {});
  }

  // 계산 관련
  double calculateHeight([double? unitRowHeight]) =>
      calculateTopOffset(widget.maximumTime, unitRowHeight: unitRowHeight);

  double calculateTopOffset(
    HourMinute time, {
    HourMinute? minimumTime,
    double? unitRowHeight,
  }) =>
      DefaultBuilders.defaultTopOffsetCalculator(
        time,
        minimumTime: minimumTime ?? widget.minimumTime,
        unitRowHeight: unitRowHeight ?? widget.style.unitRowHeight,
        unit: widget.style.unit,
      );

  HourMinute calculateOffsetToHourMinute(double posY) {
    double unitRowHeight = widget.style.unitRowHeight;
    double calcMinute = posY * widget.style.unit.minute / unitRowHeight;

    if (calcMinute < 0) {
      return widget.minimumTime;
    }

    int hour = calcMinute ~/ 60;
    int minute = (calcMinute % 60).round();
    return widget.minimumTime.add(HourMinute(hour: hour, minute: minute));
  }

  double clampToOffsetByHourMinute(HourMinute time, [ScheduleUnit? unit]) {
    final totalMinutes = time.hour * 60 + time.minute;
    final unitMinutes = (unit ?? widget.style.unit).minute;

    final clampMinutes = (totalMinutes / unitMinutes).floor() * unitMinutes;
    final clampTime = HourMinute(
      hour: clampMinutes ~/ 60,
      minute: clampMinutes % 60,
    );
    return calculateTopOffset(clampTime,
        unitRowHeight: widget.style.unitRowHeight);
  }
}

class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
