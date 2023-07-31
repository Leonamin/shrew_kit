import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class LibCalendarView extends StatelessWidget {
  const LibCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DayView(
        controller: EventController(),
        onDateTap: (date) {},
        onDateLongPress: (date) {},
      ),
    );
  }
}
