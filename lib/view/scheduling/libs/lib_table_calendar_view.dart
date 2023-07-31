import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class LibTableCalendarView extends StatelessWidget {
  const LibTableCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.now().subtract(Duration(days: 30 * 12 * 3)),
        lastDay: DateTime.now().add(Duration(days: 30 * 12 * 3)),
      ),
    );
  }
}
