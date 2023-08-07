import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/event_grid.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule.dart';
import 'package:shrew_kit/component/schedul_calendar/typedefs.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column_style.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/builders.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_style.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/hour_minute.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule_unit.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

enum HoverStartEvent {
  tap,
  longTap,
}

class DailyScheduleView extends StatefulWidget {
  DailyScheduleView({
    super.key,
    this.events = const [],
    this.style = const DailyScheduleStyle.defaultStyle(),
    required DateTime date,
    this.minimumTime = HourMinute.min,
    this.maximumTime = HourMinute.max,
    this.unitColumnStyle = const UnitColumnStyle(),
    this.isRTL = false,
    this.hoverStartEvent = HoverStartEvent.longTap, // TODO : 관련 기능은 나중에
    this.unitColumnTimeBuilder,
    this.unitColumnBackgroundBuilder,
    this.unitColumnTapCallback,
    this.onBackgroundTapped,
    this.currentTimeIndicatorBuilder,
    this.onHoverEnd,
    this.eventBuilder,
  })  : date = date.withStartTime(),
        initialTime = DateTime.now(); // FIXME : 오늘 날짜 아닌 날짜 비교해서 넣어주자

  final List<Schedule> events;
  final DailyScheduleStyle style;
  final DateTime date;
  final HourMinute minimumTime;
  final HourMinute maximumTime;
  final DateTime initialTime;
  final UnitColumnStyle unitColumnStyle;
  final bool isRTL;
  final HoverStartEvent hoverStartEvent;

  final UnitColumnTimeBuilder? unitColumnTimeBuilder;
  final UnitColumnBackgroundBuilder? unitColumnBackgroundBuilder;
  final UnitColumnTapCallback? unitColumnTapCallback;
  final BackgroundTapCallback? onBackgroundTapped;
  final CurrentTimeIndicatorBuilder? currentTimeIndicatorBuilder;
  final HoverEndCallback? onHoverEnd;
  final EventBuilder? eventBuilder;

  @override
  State<DailyScheduleView> createState() => DailyScheduleViewState();
}

class DailyScheduleViewState extends State<DailyScheduleView> {
  final ScrollController verticalScrollController = ScrollController();
  final Map<Schedule, EventDrawProperties> eventsDrawProperties = HashMap();

  /// The flutter week view events.
  late List<Schedule> events;

  bool isDragging = false;
  double hoverPos = 0;

  bool get shouldScrollToInitialTime =>
      widget.minimumTime
          .atDate(widget.initialTime)
          .isBefore(widget.initialTime) &&
      widget.maximumTime.atDate(widget.initialTime).isAfter(widget.initialTime);

  @override
  void initState() {
    super.initState();
    scheduleScrollToInitialTime();
    reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(createEventsDrawProperties);
      }
    });
  }

  @override
  void didUpdateWidget(DailyScheduleView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.date != widget.date) {
      scheduleScrollToInitialTime();
    }

    reset();
    createEventsDrawProperties();
  }

  @override
  Widget build(BuildContext context) {
    var mainWidget = createMainWidget();
    return mainWidget;
  }

  // 위젯 관련
  Widget createMainWidget() {
    List<Widget> children = [];

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
      left: widget.unitColumnStyle.width,
      right: 0,
      top: hoverPos,
      child: EventTile(
        height: widget.style.unitRowHeight,
      ),
    );

    children.add(
      Positioned(
        top: 0,
        left: 0,
        child: UnitColumn.fromHeadersWidgetState(parent: this),
      ),
    );

    children.addAll(
        eventsDrawProperties.entries.map((entry) => entry.value.createWidget(
              context,
              widget,
              null,
              entry.key,
            )));

    Widget mainWidget = SizedBox(
      height: calculateHeight(),
      child: Stack(children: [
        createBackground(),
        ...children,
        // add Background
        // add Gesture
        gesture,
        // add Events
        // add hovering event
        if (isDragging) previewEvnet
      ]),
    );

    mainWidget = SingleChildScrollView(
      controller: verticalScrollController,
      physics: const BouncingScrollPhysics(),
      child: mainWidget,
    );

    return mainWidget;
  }

  @override
  void dispose() {
    super.dispose();
    verticalScrollController.dispose();
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
    final hourMinute = calculateOffsetToHourMinute(hoverPos);
    final dt = widget.date
        .of(hour: hourMinute.hour, minute: hourMinute.minute, second: 0);
    widget.onHoverEnd?.call(dt);
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

  void scheduleScrollToInitialTime() {
    if (shouldScrollToInitialTime) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => scrollToInitialTime());
    }
  }

  void scrollToInitialTime() {
    if (mounted && verticalScrollController.hasClients) {
      double topOffset = calculateTopOffset(
          HourMinute.fromDateTime(dateTime: widget.initialTime));
      verticalScrollController.jumpTo(math.min(
          topOffset, verticalScrollController.position.maxScrollExtent));
    }
  }

  void reset() {
    eventsDrawProperties.clear();
    events = List.of(widget.events)..sort();
  }

  /// Creates the events draw properties and add them to the current list.
  void createEventsDrawProperties() {
    EventGrid eventsGrid = EventGrid();
    for (Schedule event in List.of(events)) {
      EventDrawProperties drawProperties = eventsDrawProperties[event] ??
          EventDrawProperties(widget, event, widget.isRTL);
      if (!drawProperties.shouldDraw) {
        events.remove(event);
        continue;
      }

      drawProperties.calculateTopAndHeight(calculateTopOffset);
      if (drawProperties.left == null || drawProperties.width == null) {
        eventsGrid.add(drawProperties);
      }

      eventsDrawProperties[event] = drawProperties;
    }

    if (eventsGrid.drawPropertiesList.isNotEmpty) {
      double eventsColumnWidth =
          (context.findRenderObject() as RenderBox).size.width -
              widget.unitColumnStyle.width;
      eventsGrid.processEvents(widget.unitColumnStyle.width, eventsColumnWidth);
    }
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
