/// Month name for history calendar (1-based month index).
String historyMonthName(int month) {
  const names = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return names[month - 1];
}

/// Number of days in the month for [year] and [month] (1-based).
int historyDaysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

/// First weekday of the month (0 = Sunday, 1 = Monday, ...).
int historyFirstWeekdayOfMonth(DateTime viewMonth) {
  return DateTime(viewMonth.year, viewMonth.month, 1).weekday % 7;
}

/// Whether [day] (1-based) in [viewMonth] is today.
bool historyIsToday(DateTime viewMonth, int day) {
  final now = DateTime.now();
  return now.year == viewMonth.year &&
      now.month == viewMonth.month &&
      now.day == day;
}
