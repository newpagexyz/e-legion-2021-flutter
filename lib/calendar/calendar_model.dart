enum CalendarEventType { deadline, meeting, next, prev }

class CalendarEvent {
  final CalendarEventType type;
  final DateTime startDate;
  final DateTime finishDate;

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
      {required this.type, required this.startDate, required this.finishDate});
}
