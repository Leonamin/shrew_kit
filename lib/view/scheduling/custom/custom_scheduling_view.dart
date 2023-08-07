import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/daily_schedule_view.dart';

class CustomSchedulingView extends StatelessWidget {
  const CustomSchedulingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DailyScheduleView(
        date: DateTime.now(),
      ),
    );
  }
}
