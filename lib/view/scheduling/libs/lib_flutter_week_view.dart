import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

class LibFlutterWeekView extends StatefulWidget {
  const LibFlutterWeekView({super.key});

  @override
  State<LibFlutterWeekView> createState() => _LibFlutterWeekViewState();
}

class _LibFlutterWeekViewState extends State<LibFlutterWeekView> {
  final _todayStart = DateTimeExt.getToday();
  final _tomorrowStart = DateTimeExt.getToday().add(Duration(days: 1));

  List<DateTime> _testDateTime = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 22; i++) {
      _testDateTime.add(_todayStart.add(Duration(minutes: i * 15)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_week_view'),
      ),
      body: Builder(builder: (_) {
        return Builder(
          builder: (context) {
            DateTime now = DateTime.now();
            DateTime date = DateTime(now.year, now.month, now.day);

            return DayView(
              onBackgroundTappedDown: (date) {
                print(date);
              },
              dragAndDropOptions: DragAndDropOptions(
                onEventDragged: (event, newStartTime) {},
              ),
              date: now,
              events: [
                ..._testDateTime.map((e) {
                  return FlutterWeekViewEvent(
                    title: 'Event ${e.minute}',
                    description: 'A description 1',
                    start: e,
                    end: e.add(const Duration(hours: 1)),
                  );
                }).toList(),
              ],
              style: DayViewStyle.fromDate(
                date: now,
                currentTimeCircleColor: Colors.pink,
              ),
            );
          },
        );
      }),
    );
  }
}
