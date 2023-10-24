import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shrew_kit/component/hour_minute.dart';
import 'package:shrew_kit/component/schedul_calendar/event_grid.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule.dart';
import 'package:shrew_kit/component/schedul_calendar/typedefs.dart';
import 'package:shrew_kit/component/schedul_calendar/unit_column_style.dart';
import 'package:shrew_kit/component/schedul_calendar/utils/builders.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_style.dart';
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
    this.previewBuilder,
    this.scrollPhysics = const ClampingScrollPhysics(),
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
  final PreviewBuilder? previewBuilder;

  // UI 관련
  final ScrollPhysics scrollPhysics;

  @override
  State<DailyScheduleView> createState() => DailyScheduleViewState();
}

class DailyScheduleViewState extends State<DailyScheduleView> {
  final ScrollController verticalScrollController = ScrollController();
  final Map<Schedule, EventDrawProperties> eventsDrawProperties = HashMap();

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
    _reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(_createEventsDrawProperties);
      }
    });
  }

  @override
  void didUpdateWidget(DailyScheduleView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.date != widget.date) {
      scheduleScrollToInitialTime();
    }

    _reset();
    _createEventsDrawProperties();
  }

  @override
  Widget build(BuildContext context) {
    var mainWidget = _createMainWidget();
    return mainWidget;
  }

  @override
  void dispose() {
    super.dispose();
    verticalScrollController.dispose();
  }

  // 위젯 관련

  /// 메인 화면 생성
  /// 배경, 제스쳐, 호버링 감지, `events`들을 그리는 역할
  Widget _createMainWidget() {
    List<Widget> children = [];

    Widget gesture = Positioned.fill(
        child: GestureDetector(
      onTapUp: (details) {
        DateTime timeOfTappedPos = widget.date.add(
            calculateOffsetToHourMinute(details.localPosition.dy).asDuration);
        widget.onBackgroundTapped?.call(timeOfTappedPos);
      },
      onLongPressStart: _onPreviewStart,
      onLongPressMoveUpdate: _onPreviewMoveUpdate,
      onLongPressEnd: _onPrivewEnd,
      onLongPressCancel: _onPreviewCancel,
    ));

    final previewStartTime = calculateOffsetToHourMinute(hoverPos).toDateTime();
    // TODO : 미리보기 단위 추가 현재는 임시로 화면 그리는 단위 삽입
    // 미리 보기 시간에 맞춰서 바꾼다.
    final previewEndTime = previewStartTime.add(widget.style.unit.duration);
    final previewWidgetHeight = widget.style.unitRowHeight;

    Widget previewEvnet = _createPreviewEventWidget(
      previewWidgetHeight,
      previewStartTime,
      previewEndTime,
    );

    children.add(
      Positioned(
        top: 0,
        left: 0,
        child: UnitColumn.fromHeadersWidgetState(parent: this),
      ),
    );

    children.addAll(
      eventsDrawProperties.entries.map(
        (each) => each.value.createWidget(
          context,
          widget,
          null,
          each.key,
        ),
      ),
    );

    Widget mainWidget = SizedBox(
      height: calculateHeight(),
      child: Stack(children: [
        _createBackground(),
        // add Background
        // add Gesture
        gesture,
        ...children,
        // add Events
        // add hovering event
        if (isDragging) previewEvnet
      ]),
    );

    mainWidget = SingleChildScrollView(
      controller: verticalScrollController,
      physics: widget.scrollPhysics,
      child: mainWidget,
    );

    return mainWidget;
  }

  Widget _createPreviewEventWidget(
    double itemHeight,
    DateTime startTime,
    DateTime endTime,
  ) =>
      Positioned(
        left: widget.unitColumnStyle.width,
        right: 0,
        top: hoverPos,
        child: widget.previewBuilder?.call(
              context,
              itemHeight,
              startTime,
              endTime,
            ) ??
            const SizedBox.shrink(),
      );

  Widget _createBackground() => Positioned.fill(
        child: CustomPaint(
          painter: widget.style.createBackgroundPainter(
            view: widget,
            topOffsetCalculator: calculateTopOffset,
          ),
        ),
      );

  /// `widge`의 `events`들을 `EventDrawProperties`로 변환하여 UI를 그린다
  void _createEventsDrawProperties() {
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

  // 호버링 관련
  void _onPreviewStart(LongPressStartDetails details) {
    isDragging = true;
    hoverPos = clampToOffsetByHourMinute(
        calculateOffsetToHourMinute(details.localPosition.dy));
    setState(() {});
  }

  void _onPreviewMoveUpdate(LongPressMoveUpdateDetails details) {
    hoverPos = clampToOffsetByHourMinute(
        calculateOffsetToHourMinute(details.localPosition.dy));
    setState(() {});
  }

  void _onPrivewEnd(LongPressEndDetails details) {
    isDragging = false;
    final hourMinute = calculateOffsetToHourMinute(hoverPos);
    final dt = widget.date
        .of(hour: hourMinute.hour, minute: hourMinute.minute, second: 0);
    widget.onHoverEnd?.call(dt);
  }

  void _onPreviewCancel() {
    isDragging = false;
    setState(() {});
  }

  // context로 접근해서 사용 가능한 함수 목록

  /// 높이를 계산
  double calculateHeight([double? unitRowHeight]) =>
      calculateTopOffset(widget.maximumTime, unitRowHeight: unitRowHeight);

  /// 시간을 기준으로 높이를 계산
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

  /// Y축 위치를 기준으로 시간을 계산
  /// hh:mm HourMinute으로 반환
  HourMinute calculateOffsetToHourMinute(double posY) {
    double unitRowHeight = widget.style.unitRowHeight;
    double calcMinute = posY * widget.style.unit.minute / unitRowHeight;

    if (calcMinute < widget.minimumTime.minute) {
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

  /// [eventsDrawProperties]를 초기화하여 다시 그린다
  /// [initState]를 제외하면 [didUpdateWidget]에서 변경사항이 발생했을 때 다시 그린다.
  void _reset() {
    eventsDrawProperties.clear();
    events = List.of(widget.events)..sort();
  }
}
