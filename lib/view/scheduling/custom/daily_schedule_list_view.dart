import 'package:flutter/material.dart';
import 'package:shrew_kit/component/schedul_calendar/schedule_unit.dart';
import 'package:shrew_kit/main.dart';
import 'package:shrew_kit/util/date_time_ext.dart';

/// unused
/// 타일 호버링 테스트용 위젯
@Deprecated('테스트용 위젯')
class DailyScheduleListView extends StatefulWidget {
  const DailyScheduleListView({super.key});

  @override
  State<DailyScheduleListView> createState() => _DailyScheduleListViewState();
}

class _DailyScheduleListViewState extends State<DailyScheduleListView> {
  static const _headerRatio = 1;
  static const _bodyRatio = 7;
  static const defaultItemHeight = 60.0;
  final ScheduleUnit _curScheduleUnit = ScheduleUnit.min5;

  final ScrollController _scrollController = ScrollController();

  double xPosition = 0;
  double yPosition = 0;
  bool isDragging = false;

  final List<DateTime> _timeList = [];

  @override
  void initState() {
    super.initState();

    _timeList.addAll(_generateTimeTable(_curScheduleUnit, DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: _timeList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: defaultItemHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: _headerRatio,
                      child: Text(
                        _timeList[index].toHM(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: _bodyRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: const Border(
                            top: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onLongPressStart: (details) {
            setState(() {
              yPosition = _calculateYPosition(details.localPosition.dy);
              isDragging = true;
            });
            logger.i(
                'localPosition dy: ${details.localPosition.dy}, scroll offset ${_scrollController.offset}');
          },
          onLongPressMoveUpdate: (details) {
            setState(() {
              yPosition = _calculateYPosition(details.localPosition.dy);
            });
          },
          onLongPressCancel: () {
            setState(() {
              isDragging = false;
            });
          },
          onLongPressEnd: (details) {
            setState(() {
              isDragging = false;
            });
            final dt = _getDateTimeOfPosition(details.localPosition.dy);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(dt.toHM()),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        if (isDragging)
          Positioned(
            left: 0,
            right: 0,
            top: yPosition,
            child: SizedBox(
              height: defaultItemHeight,
              child: Row(
                children: [
                  Expanded(
                    flex: _headerRatio,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    flex: _bodyRatio,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<DateTime> _generateTimeTable(ScheduleUnit unit, DateTime dt) {
    final start = DateTime(dt.year, dt.month, dt.day);
    final end = DateTime(dt.year, dt.month, dt.day + 1);
    final timeList = <DateTime>[];
    for (var i = start; i.isBefore(end); i = i.add(unit.duration)) {
      timeList.add(i);
    }
    return timeList;
  }

  DateTime _getDateTimeOfPosition(double dy) {
    int t = (_scrollController.offset + dy) ~/ defaultItemHeight;
    return _timeList[t];
  }

  double _calculateYPosition(double dy) {
    final centerDy = dy;
    final result = _customRound(
            centerDy + _remainder(_scrollController.offset, defaultItemHeight),
            defaultItemHeight) -
        _remainder(_scrollController.offset, defaultItemHeight);
    return result;
  }

  double _customRound(double n, double m) {
    return (n ~/ m) * m;
  }

  double _remainder(double n, double m) {
    return n % m;
  }
}
