enum CalendarEventType { deadline, meeting, next, prev }

class CalendarEvent {
  final CalendarEventType type;
  final DateTime startDate;
  final DateTime finishDate;

  final String name;
  final int idx;
  final String description;
  final String place;

  String formatDate(DateTime pov, {bool start = false}) {
    final date = start ? startDate : finishDate;
    var str = '';
    if (date.month == pov.month && date.day == pov.day) {
      str = '${date.hour}:${date.minute}';
    } else {
      str = '${date.day}.${date.month}';
    }

    return str;
  }

  CalendarEvent(
      {required this.type,
      required this.startDate,
      required this.finishDate,
      required this.description,
      required this.idx,
      required this.name,
      required this.place});

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
        idx: int.parse(
          json['id'] ?? '0',
        ),
        description: json['description'],
        finishDate: json['add_time'] != null
            ? DateTime.parse(json['add_time'])
            : json['end_time'] == null
                ? DateTime.parse(json['start_time'])
                : DateTime.parse(json['end_time']),
        startDate: json['add_time'] == null
            ? DateTime.parse(json['start_time'])
            : DateTime.parse(json['add_time']),
        name: json['name'],
        place: json['place'] ?? '',
        type: CalendarEventType.values[int.parse(json['type'] ?? '0')]);
  }
}
