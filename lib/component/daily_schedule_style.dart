import 'package:shrew_kit/component/schedule_unit.dart';

class DailyScheduleStyle {
  final ScheduleUnit unit;
  final double unitRowHeight;

  //  unit 당 기본 높이
  //  unit이 5분이고 기본 높이가 50이면 5분당 50픽셀, 1시간당 600픽셀

  const DailyScheduleStyle({
    ScheduleUnit? unit,
    double? unitRowHeight,
  })  : unit = unit ?? ScheduleUnit.min30,
        unitRowHeight = unitRowHeight ?? 50;

  const DailyScheduleStyle.defaultStyle()
      : this(
          unit: ScheduleUnit.min30,
          unitRowHeight: 50,
        );
}
