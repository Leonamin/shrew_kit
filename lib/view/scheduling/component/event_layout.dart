import 'package:flutter/material.dart';
import 'package:shrew_kit/util/date_time_ext.dart';
import 'package:shrew_kit/view/scheduling/component/calendar_event.dart';

class EventLayout extends StatefulWidget {
  const EventLayout({super.key});

  @override
  State<EventLayout> createState() => _EventLayoutState();
}

class _EventLayoutState extends State<EventLayout> {
  final defaultHeight = 60.0;
  final _todayStart = DateTimeExt.getToday();
  final List<DateTime> _testDateTime = [];
  final List<CalendarEvent> events = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 22; i++) {
      _testDateTime.add(_todayStart.add(Duration(minutes: i * 30)));
    }
    for (var i = 0; i < _testDateTime.length; i++) {
      events.add(CalendarEvent(
        'Event $i',
        _testDateTime[i],
        // _testDateTime[i].add(const Duration(minutes: 59)),
        _testDateTime[i].add(const Duration(hours: 1)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    layoutEvents(events);

    return SingleChildScrollView(
      child: SizedBox(
        height: defaultHeight * 24,
        child: Stack(
          children: [
            // 1 시간 단위로 표시선 작성
            ...List.generate(
              24,
              (index) => Positioned(
                top: index * defaultHeight,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
            ),
            ...events.map<Widget>((e) {
              return Positioned(
                top: e.start.hour * defaultHeight +
                    e.start.minute / 60 * defaultHeight,
                left: e.left * MediaQuery.of(context).size.width,
                right: (1 - e.right) * MediaQuery.of(context).size.width,
                child: Container(
                  height: defaultHeight, // You can adjust the height as needed
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        e.title,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  void layoutEvents(List<CalendarEvent> events) {
    var columns = <List<CalendarEvent>>[];
    events.sort(sortByStartOrEnd);
    DateTime? lastEventEnding;
    for (var ev in events) {
      if (isSameOrAfter(ev.start, lastEventEnding)) {
        packEvents(columns);
        columns.clear();
        lastEventEnding = null;
      }
      bool placed = false;
      for (var col in columns) {
        if (!col.last.collidesWith(ev)) {
          col.add(ev);
          placed = true;
          break;
        }
      }
      if (!placed) {
        columns.add(<CalendarEvent>[ev]);
      }
      if (lastEventEnding == null || ev.end.isAfter(lastEventEnding)) {
        lastEventEnding = ev.end;
      }
    }
    if (columns.isNotEmpty) {
      packEvents(columns);
    }
  }

  void packEvents(List<List<CalendarEvent>> columns) {
    var numColumns = columns.length.toDouble();
    var iColumn = 0;
    for (var col in columns) {
      for (var ev in col) {
        var colSpan = expandEvent(ev, iColumn, columns);
        ev.left = iColumn / numColumns;
        ev.right = (iColumn + colSpan) / numColumns;
      }
      iColumn++;
    }
  }

  int expandEvent(
      CalendarEvent ev, int iColumn, List<List<CalendarEvent>> columns) {
    var colSpan = 1;
    for (var col in columns.skip(iColumn + 1)) {
      for (var ev1 in col) {
        if (ev1.collidesWith(ev)) {
          return colSpan;
        }
      }
      colSpan++;
    }
    return colSpan;
  }

  int sortByStartOrEnd(CalendarEvent a, CalendarEvent b) {
    var res = a.start.compareTo(b.start);
    if (res == 0) {
      res = a.end.compareTo(b.end);
    }
    return res;
  }

  bool isSameOrAfter(DateTime? a, DateTime? b) =>
      a == null || b == null || a.isAfter(b) || a.isAtSameMomentAs(b);
}
