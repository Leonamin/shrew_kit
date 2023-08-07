import 'package:flutter/material.dart';
import 'package:shrew_kit/component/shrew_icon_button.dart';
import 'package:go_router/go_router.dart';
import 'package:shrew_kit/util/date_time_ext.dart';
import 'package:shrew_kit/view/scheduling/custom/add_schedule_form.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({
    super.key,
    this.dtStart,
    this.dtEnd,
  });
  final DateTime? dtStart;
  final DateTime? dtEnd;

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  final tcTitle = TextEditingController();

  late DateTime dtStart = widget.dtStart ?? DateTime.now();
  late DateTime dtEnd = widget.dtEnd ?? DateTime.now().add(Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    children.add(_InfoRow(
      widget: TextField(
        controller: tcTitle,
        maxLines: 1,
      ),
    ));

    children.add(_InfoRow(
        widget: InkWell(
            onTap: () async {
              final selectedTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (selectedTime != null) {
                setState(() {
                  dtStart = DateTime.now().of(
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                    second: 0,
                  );
                });
              }
            },
            child: Text('시작 시간 : ${dtStart.toHM()}'))));
    children.add(_InfoRow(
        widget: InkWell(
            onTap: () async {
              final selectedTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (selectedTime != null) {
                setState(() {
                  dtEnd = DateTime.now().of(
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                    second: 0,
                  );
                });
              }
            },
            child: Text('종료 시간 : ${dtEnd.toHM()}'))));

    return Scaffold(
      appBar: AppBar(
        leading: ShrewIconButton(
          icon: const Icon(Icons.close_outlined),
          onTap: () => context.pop(),
        ),
        actions: [
          ShrewIconButton(
            icon: const Icon(
              Icons.check_outlined,
            ),
            onTap: () {
              _createSchedule();
            },
          ),
        ],
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Divider(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tcTitle.dispose();
  }

  void _createSchedule() {
    final res =
        AddScheduleForm(title: tcTitle.text, start: dtStart, end: dtEnd);
    context.pop(res);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    super.key,
    this.leading = const Icon(Icons.circle),
    required this.widget,
  });
  final Widget leading;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 50,
            height: 50,
            child: leading,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ],
    );
  }
}
