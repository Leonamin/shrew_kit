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
        eventBuilder: (context, scechdule, dayView, height, width) {
          // TODO : 렌더링 에러 확인해야함
          return SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    scechdule.title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          );
        },
        previewBuilder: (context, height, start, end) {
          return _PreviewWidget(
            maxHeight: height,
            start: start,
            end: end,
          );
        },
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

class _PreviewWidget extends StatelessWidget {
  const _PreviewWidget({
    super.key,
    required this.maxHeight,
    required this.start,
    required this.end,
  });

  final double maxHeight;
  final DateTime start;
  final DateTime? end;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: start.toHM(),
                  ),
                  if (end != null) ...[
                    const TextSpan(text: ' '),
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_right_rounded,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: end!.toHM()),
                  ]
                ],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
