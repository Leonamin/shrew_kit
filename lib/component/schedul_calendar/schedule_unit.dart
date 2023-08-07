enum ScheduleUnit {
  min1,
  min5,
  min10,
  min15,
  min20,
  min30,
  min40,
  min60,
  min90,
  min120,
  min180,
  min240,
  min360,
  min480,
  min720,
  min1440,
}

extension ScheduleUnitExt on ScheduleUnit {
  int get minute {
    switch (this) {
      case ScheduleUnit.min1:
        return 1;
      case ScheduleUnit.min5:
        return 5;
      case ScheduleUnit.min10:
        return 10;
      case ScheduleUnit.min15:
        return 15;
      case ScheduleUnit.min20:
        return 20;
      case ScheduleUnit.min30:
        return 30;
      case ScheduleUnit.min40:
        return 40;
      case ScheduleUnit.min60:
        return 60;
      case ScheduleUnit.min90:
        return 90;
      case ScheduleUnit.min120:
        return 120;
      case ScheduleUnit.min180:
        return 180;
      case ScheduleUnit.min240:
        return 240;
      case ScheduleUnit.min360:
        return 360;
      case ScheduleUnit.min480:
        return 480;
      case ScheduleUnit.min720:
        return 720;
      case ScheduleUnit.min1440:
        return 1440;
    }
  }

  Duration get duration {
    switch (this) {
      case ScheduleUnit.min1:
        return const Duration(minutes: 1);
      case ScheduleUnit.min5:
        return const Duration(minutes: 5);
      case ScheduleUnit.min10:
        return const Duration(minutes: 10);
      case ScheduleUnit.min15:
        return const Duration(minutes: 15);
      case ScheduleUnit.min20:
        return const Duration(minutes: 20);
      case ScheduleUnit.min30:
        return const Duration(minutes: 30);
      case ScheduleUnit.min40:
        return const Duration(minutes: 40);
      case ScheduleUnit.min60:
        return const Duration(minutes: 60);
      case ScheduleUnit.min90:
        return const Duration(minutes: 90);
      case ScheduleUnit.min120:
        return const Duration(minutes: 120);
      case ScheduleUnit.min180:
        return const Duration(minutes: 180);
      case ScheduleUnit.min240:
        return const Duration(minutes: 240);
      case ScheduleUnit.min360:
        return const Duration(minutes: 360);
      case ScheduleUnit.min480:
        return const Duration(minutes: 480);
      case ScheduleUnit.min720:
        return const Duration(minutes: 720);
      case ScheduleUnit.min1440:
        return const Duration(minutes: 1440);
    }
  }
}
