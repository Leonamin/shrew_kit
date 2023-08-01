class CalendarEvent {
  final String title;
  final DateTime start;
  final DateTime end;
  double left;
  double right;

  CalendarEvent(this.title, this.start, this.end,
      {this.left = 0, this.right = 1});

  bool collidesWith(CalendarEvent other) {
    return !(start.isAfter(other.end) || end.isBefore(other.start));
  }
}
