abstract class HistoryEvent {}

class HistoryLoadRequested extends HistoryEvent {}

class HistoryMonthChanged extends HistoryEvent {
  HistoryMonthChanged(this.month);
  final DateTime month;
}

class HistoryDaySelected extends HistoryEvent {
  HistoryDaySelected(this.day);
  final int? day;
}

class HistoryManualPresenceApplied extends HistoryEvent {
  HistoryManualPresenceApplied(this.date, this.presence);
  final DateTime date;
  final Map<String, bool> presence;
}

class HistoryFilterChanged extends HistoryEvent {
  HistoryFilterChanged(this.placeId);
  final String? placeId;
}
