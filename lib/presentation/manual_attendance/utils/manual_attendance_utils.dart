import 'package:flutter/material.dart';
import 'package:i_was_there/domain/places/entities/place.dart';

/// Formatted date string for manual attendance (e.g. "Monday, Jan 15").
String manualAttendanceFormatDate(DateTime d) {
  const days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  final weekday = days[d.weekday - 1];
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '$weekday, ${months[d.month - 1]} ${d.day}';
}

/// Icon for place based on name (office, gym, etc.).
IconData manualAttendanceIconForPlace(Place place) {
  final n = place.name.toLowerCase();
  if (n.contains('office') || n.contains('corporate')) return Icons.corporate_fare;
  if (n.contains('gym') || n.contains('fitness')) return Icons.fitness_center;
  if (n.contains('cowork') || n.contains('desk')) return Icons.desk;
  if (n.contains('client') || n.contains('meeting')) return Icons.meeting_room;
  return Icons.place;
}
