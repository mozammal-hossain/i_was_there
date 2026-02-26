import 'package:flutter/material.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/manual_attendance/widgets/manual_attendance_footer.dart';
import 'package:i_was_there/presentation/manual_attendance/widgets/manual_attendance_header.dart';
import 'package:i_was_there/presentation/manual_attendance/widgets/manual_attendance_place_list.dart';

/// Presentational body of the manual attendance bottom sheet.
class ManualAttendanceSheetContent extends StatelessWidget {
  const ManualAttendanceSheetContent({
    super.key,
    required this.theme,
    required this.isDark,
    required this.selectedDate,
    required this.onChangeDateTap,
    required this.places,
    required this.presenceByPlaceId,
    required this.loading,
    required this.onPresenceChanged,
    required this.onApply,
    required this.onCancel,
  });

  final ThemeData theme;
  final bool isDark;
  final DateTime selectedDate;
  final VoidCallback onChangeDateTap;
  final List<Place> places;
  final Map<String, bool> presenceByPlaceId;
  final bool loading;
  final void Function(String placeId, bool value) onPresenceChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF24303F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ManualAttendanceHeader(
              selectedDate: selectedDate,
              theme: theme,
              isDark: isDark,
              onChangeDateTap: onChangeDateTap,
            ),
            Flexible(
              child: ManualAttendancePlaceList(
                places: places,
                presenceByPlaceId: presenceByPlaceId,
                isDark: isDark,
                loading: loading,
                onPresenceChanged: onPresenceChanged,
              ),
            ),
            ManualAttendanceFooter(
              theme: theme,
              isDark: isDark,
              onApply: onApply,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
