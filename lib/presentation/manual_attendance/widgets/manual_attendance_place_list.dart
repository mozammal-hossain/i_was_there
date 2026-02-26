import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/manual_attendance/utils/manual_attendance_utils.dart';
import 'package:i_was_there/presentation/manual_attendance/widgets/manual_attendance_place_row.dart';

/// List of places with presence toggles for manual attendance.
class ManualAttendancePlaceList extends StatelessWidget {
  const ManualAttendancePlaceList({
    super.key,
    required this.places,
    required this.presenceByPlaceId,
    required this.isDark,
    required this.loading,
    required this.onPresenceChanged,
  });

  final List<Place> places;
  final Map<String, bool> presenceByPlaceId;
  final bool isDark;
  final bool loading;
  final void Function(String placeId, bool value) onPresenceChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.spacingXl,
        vertical: AppSize.spacingM,
      ),
      children: places.map((place) {
        final present = presenceByPlaceId[place.id] ?? false;
        return ManualAttendancePlaceRow(
          place: place,
          present: present,
          isDark: isDark,
          icon: manualAttendanceIconForPlace(place),
          onChanged: (v) => onPresenceChanged(place.id, v),
          enabled: !loading,
        );
      }).toList(),
    );
  }
}
