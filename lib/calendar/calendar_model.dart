enum CalendarEventType { deadline, meeting, next, prev }

class CalendarEvent {
  final CalendarEventType type;
  CalendarEvent({required this.type});
}
