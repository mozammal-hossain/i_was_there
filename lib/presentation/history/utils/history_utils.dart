import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Month name for history calendar (full month and year) localized from
/// the current [BuildContext].
String historyMonthName(DateTime viewMonth, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  // Use long month name, e.g. "February" or localized equivalent.
  return DateFormat('MMMM', locale).format(viewMonth);
}

/// Number of days in the month for [year] and [month] (1-based).
int historyDaysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

/// First weekday of the month adjusted to the locale's first day of
/// week. Returns an index in 0..6 where 0 corresponds to the first weekday
/// column that should appear on the calendar grid.
int historyFirstWeekdayOfMonth(DateTime viewMonth, BuildContext context) {
  final firstDayIndex = MaterialLocalizations.of(
    context,
  ).firstDayOfWeekIndex; // 0=Sunday
  // the week day of the 1st as 0=Sunday..6=Saturday
  final weekdayOfFirst =
      DateTime(viewMonth.year, viewMonth.month, 1).weekday % 7;
  // compute offset relative to locale's first day
  int offset = weekdayOfFirst - firstDayIndex;
  if (offset < 0) offset += 7;
  return offset;
}

/// Whether [day] (1-based) in [viewMonth] is today.
bool historyIsToday(DateTime viewMonth, int day) {
  final now = DateTime.now();
  return now.year == viewMonth.year &&
      now.month == viewMonth.month &&
      now.day == day;
}
