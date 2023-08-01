import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

class LibCalendarView extends StatefulWidget {
  const LibCalendarView({super.key});

  @override
  State<LibCalendarView> createState() => _LibCalendarViewState();
}

class _LibCalendarViewState extends State<LibCalendarView> {
  final _controller = EventController();

  final _todayStart = DateTimeExt.getToday();
  final _tomorrowStart = DateTimeExt.getToday().add(Duration(days: 1));

  List<DateTime> _testDateTime = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 22; i++) {
      _testDateTime.add(_todayStart.add(Duration(minutes: i * 30)));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var i = 0; i < _testDateTime.length; i++) {
      final eventToday = CalendarEventData(
        date: _todayStart,
        startTime: _testDateTime[i],
        // 시작 시간, 끝 시간 겹치면 안됨
        endTime: _testDateTime[i].add(const Duration(minutes: 30)),
        // endTime: _testDateTime[i].add(const Duration(minutes: 29)),
        title: 'Event $i',
      );
      final eventTomorrow = CalendarEventData(
        date: _tomorrowStart,
        startTime: _testDateTime[i],
        endTime: _testDateTime[i].add(const Duration(minutes: 29)),
        title: 'Event $i',
      );
      _controller.add(eventToday);
      _controller.add(eventTomorrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('calendar_view'),
      ),
      body: DayView(
        controller: _controller,
        onDateTap: (date) {},
        onDateLongPress: (date) {},
        eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
          return Tooltip(
            message:
                '${events[0].title} - ${events[0].startTime?.toHM()} - ${events[0].endTime?.toHM()}',
            child: Container(
              color: Color.fromARGB(255, 242, 209, 255),
            ),
          );
        },
      ),
    );
  }
}
