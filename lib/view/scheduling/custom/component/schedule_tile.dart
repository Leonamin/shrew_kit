part of '../custom_scheduling_view.dart';

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({
    super.key,
    required this.schedule,
    required this.height,
    required this.width,
  });

  final Schedule schedule;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(1.0).copyWith(bottom: 2),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: InkWell(
            onTap: () {},
            splashColor: Colors.black,
            child: Center(
              child: Text(
                schedule.title,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
