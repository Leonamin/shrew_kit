import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/common/config/routes.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_view.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule_unit.dart';
import 'package:shrew_kit/util/date_time_ext.dart';
import 'package:shrew_kit/view/scheduling/custom/add_schedule_form.dart';

class CustomSchedulingView extends StatefulWidget {
  const CustomSchedulingView({super.key});

  @override
  State<CustomSchedulingView> createState() => _CustomSchedulingViewState();
}

class _CustomSchedulingViewState extends State<CustomSchedulingView> {
  ScheduleUnit unit = ScheduleUnit.min30;
  List<Schedule> scheduleList = [
    Schedule(
        title: '미리 작성된 스케줄',
        description: 'no',
        start: DateTime.now().of(hour: 2, minute: 0, second: 0),
        end: DateTime.now().of(hour: 3, minute: 0, second: 0))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DailyScheduleView(
        events: scheduleList,
        date: DateTime.now(),
        onHoverEnd: onPreviewCalled,
      ),
    );
  }

  onPreviewCalled(DateTime dt) {
    context.pushNamed(
      CustomScheduleChildRoutes.addSchedule.name,
      extra: {'dtStart': dt, 'dtEnd': dt.add(unit.duration)},
    ).then((value) {
      if (value != null && value is AddScheduleForm) {
        addEvent(value);
      }
    });
  }

  addEvent(AddScheduleForm form) {
    final schedule = Schedule(
        title: form.title, description: '', start: form.start, end: form.end);
    scheduleList.add(schedule);
    setState(() {});
  }
}
