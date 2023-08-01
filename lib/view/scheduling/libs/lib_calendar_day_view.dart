import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

class LibCalendarDayView extends StatefulWidget {
  const LibCalendarDayView({super.key});

  @override
  State<LibCalendarDayView> createState() => _LibCalendarDayViewState();
}

class _LibCalendarDayViewState extends State<LibCalendarDayView> {
  final _todayStart = DateTimeExt.getToday();

  List<DateTime> _testDateTime = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 22; i++) {
      _testDateTime.add(_todayStart.add(Duration(minutes: i * 30)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('calendar_day_view'),
      ),
      body: OverFlowCalendarDayView<String>(
        events: [
          for (var i = 0; i < _testDateTime.length; i++)
            DayEvent(
              start: TimeOfDay.fromDateTime(_testDateTime[i]),
              end: TimeOfDay.fromDateTime(
                  _testDateTime[i].add(const Duration(hours: 1))),
              value: 'Event $i',
            ),
        ],
        dividerColor: Colors.black,
        startOfDay: const TimeOfDay(hour: 00, minute: 0),
        endOfDay: const TimeOfDay(hour: 23, minute: 0),
        timeGap: 60,
        renderRowAsListView: true,
        showCurrentTimeLine: true,
        showMoreOnRowButton: true,
        overflowItemBuilder: (context, constraints, itemIndex, event) {
          return Tooltip(
            message:
                '${event.value} - ${event.start.format(context)} - ${event.end?.format(context)}',
            child: Container(
              constraints: constraints,
              child: Card(
                child: Text(event.value),
              ),
            ),
          );
        },
      ),
    );
  }
}
