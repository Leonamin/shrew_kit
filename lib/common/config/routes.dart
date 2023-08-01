enum ShrewRoutes {
  home,
  jumpPageView,
  testAnimatedListView,
  cubeShrewView,
  cubeHamsterView,
  neo,
  concentric,
  fadeInOut,
  testAnimation,
  testSlider,
  colorChart,
  scheduling,
}

enum SchedulingRoutes {
  custom,
  calendarAlgorithm,
  flutterWeekView,
  tableCalendar,
  calendarView,
  calendarDayView,
}

extension ShrewRoutesExt on ShrewRoutes {
  String get path {
    switch (this) {
      // all case
      case ShrewRoutes.home:
        return '/';
      case ShrewRoutes.jumpPageView:
        return 'jump_page_view';
      case ShrewRoutes.testAnimatedListView:
        return 'test_animated_list_view';
      case ShrewRoutes.cubeShrewView:
        return 'cube_shrew_view';
      case ShrewRoutes.cubeHamsterView:
        return 'cube_hamster_view';
      case ShrewRoutes.neo:
        return 'neo';
      case ShrewRoutes.concentric:
        return 'concentric';
      case ShrewRoutes.fadeInOut:
        return 'fadeinout';
      case ShrewRoutes.testAnimation:
        return 'test_animation';
      case ShrewRoutes.testSlider:
        return 'test_slider';
      case ShrewRoutes.colorChart:
        return 'color_chart';
      case ShrewRoutes.scheduling:
        return 'scheduling';
    }
  }

  String get name {
    switch (this) {
      // all case
      case ShrewRoutes.home:
        return 'home';
      case ShrewRoutes.jumpPageView:
        return 'jump_page_view';
      case ShrewRoutes.testAnimatedListView:
        return 'test_animated_list_view';
      case ShrewRoutes.cubeShrewView:
        return 'cube_shrew_view';
      case ShrewRoutes.cubeHamsterView:
        return 'cube_hamster_view';
      case ShrewRoutes.neo:
        return 'neo';
      case ShrewRoutes.concentric:
        return 'concentric';
      case ShrewRoutes.fadeInOut:
        return 'fadeinout';
      case ShrewRoutes.testAnimation:
        return 'test_animation';
      case ShrewRoutes.testSlider:
        return 'test_slider';
      case ShrewRoutes.colorChart:
        return 'color_chart';
      case ShrewRoutes.scheduling:
        return 'scheduling';
    }
  }
}

extension SchedulingRoutesExt on SchedulingRoutes {
  String get path {
    switch (this) {
      // all case
      case SchedulingRoutes.custom:
        return 'custom';
      case SchedulingRoutes.calendarAlgorithm:
        return 'calendar_algorithm';
      case SchedulingRoutes.flutterWeekView:
        return 'flutter_week_view';
      case SchedulingRoutes.tableCalendar:
        return 'table_calendar';
      case SchedulingRoutes.calendarView:
        return 'calendar_view';
      case SchedulingRoutes.calendarDayView:
        return 'calendar_day_view';
    }
  }

  String get name {
    switch (this) {
      // all case
      case SchedulingRoutes.custom:
        return 'custom';
      case SchedulingRoutes.calendarAlgorithm:
        return 'calendar_algorithm';
      case SchedulingRoutes.flutterWeekView:
        return 'flutter_week_view';
      case SchedulingRoutes.tableCalendar:
        return 'table_calendar';
      case SchedulingRoutes.calendarView:
        return 'calendar_view';
      case SchedulingRoutes.calendarDayView:
        return 'calendar_day_view';
    }
  }
}
