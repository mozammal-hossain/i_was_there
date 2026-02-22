abstract class CalendarEvent {}

class CalendarLoadRequested extends CalendarEvent {}

class CalendarMonthChanged extends CalendarEvent {
  CalendarMonthChanged(this.month);
  final DateTime month;
}

class CalendarDaySelected extends CalendarEvent {
  CalendarDaySelected(this.day);
  final int? day;
}

class CalendarManualPresenceApplied extends CalendarEvent {
  CalendarManualPresenceApplied(this.date, this.presence);
  final DateTime date;
  final Map<String, bool> presence;
}
