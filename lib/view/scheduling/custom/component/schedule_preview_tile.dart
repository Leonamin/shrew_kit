part of '../custom_scheduling_view.dart';

class _SchedulePreviewTile extends StatelessWidget {
  const _SchedulePreviewTile({
    super.key,
    required this.maxHeight,
    required this.start,
    required this.end,
  });

  final double maxHeight;
  final DateTime start;
  final DateTime? end;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: ColorHue.bluePrimary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: start.toHM(),
                  ),
                  if (end != null) ...[
                    const TextSpan(text: ' '),
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_right_rounded,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: end!.toHM()),
                  ]
                ],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
