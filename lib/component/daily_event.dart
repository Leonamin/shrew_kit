class DailyEvent<T> {
  final String title;
  final DateTime start;
  final DateTime end;

  // 주어진 너비에서 위치할 비율 주어진 너비가 300이고 left가 0.5이면 150px에 위치
  double left;
  // 주어진 너비에서 위치할 비율 주어진 너비가 300이고 right가 0.8이면 240px에 위치
  double right;
  T? data;

  DailyEvent(
    this.title,
    this.start,
    this.end, {
    this.left = 0,
    this.right = 1,
    this.data,
  });

  bool collidesWith(DailyEvent other) {
    return !(start.isAfter(other.end) || end.isBefore(other.start));
  }
}
