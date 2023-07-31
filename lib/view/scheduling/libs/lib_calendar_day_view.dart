import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';

class LibCalendarDayView extends StatelessWidget {
  const LibCalendarDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OverFlowCalendarDayView<String>(
        events: [],
        dividerColor: Colors.black,
        startOfDay: const TimeOfDay(hour: 00, minute: 0),
        endOfDay: const TimeOfDay(hour: 23, minute: 0),
        timeGap: 60,
        renderRowAsListView: true,
        showCurrentTimeLine: true,
        showMoreOnRowButton: true,
        overflowItemBuilder: (context, constraints, itemIndex, event) {
          return Container(
            constraints: constraints,
            child: Card(
              child: Text(event.value),
            ),
          );
        },
      ),
    );
  }
}
