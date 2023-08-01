import 'package:flutter/material.dart';
import 'package:shrew_kit/component/daily_schedule_view.dart';
import 'package:shrew_kit/view/scheduling/custom/daily_schedule_list_view.dart';

class CustomSchedulingView extends StatelessWidget {
  const CustomSchedulingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DailyScheduleView(),
    );
  }
}
