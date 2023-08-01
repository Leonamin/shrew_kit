import 'package:flutter/material.dart';
import 'package:shrew_kit/view/scheduling/component/event_layout.dart';

class CalendarAlgorithmView extends StatelessWidget {
  const CalendarAlgorithmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const EventLayout(),
    );
  }
}
