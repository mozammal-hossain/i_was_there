import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/manual_attendance/utils/manual_attendance_utils.dart';
import 'package:i_was_there/presentation/manual_attendance/widgets/manual_attendance_sheet_content.dart';

/// Manual presence override (HTML: manual_attendance.html). Date + list of places with toggles.
/// Toggles reflect that day's presence when [initialPresenceByPlaceId] or [getPresenceForDate] is provided.
class ManualAttendancePage extends StatefulWidget {
  const ManualAttendancePage({
    super.key,
    required this.places,
    this.initialDate,
    this.initialPresenceByPlaceId,
    this.getPresenceForDate,
    this.onApply,
    this.onCancel,
  });

  final List<Place> places;
  final DateTime? initialDate;
  final Map<String, bool>? initialPresenceByPlaceId;
  final Future<Map<String, bool>> Function(DateTime date)? getPresenceForDate;
  final void Function(DateTime date, Map<String, bool> placePresence)? onApply;
  final VoidCallback? onCancel;

  @override
  State<ManualAttendancePage> createState() => _ManualAttendancePageState();
}

class _ManualAttendancePageState extends State<ManualAttendancePage> {
  late DateTime _selectedDate;
  late Map<String, bool> _presenceByPlaceId;
  bool _loadingPresence = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _presenceByPlaceId = buildPresenceMap(widget.places, widget.initialPresenceByPlaceId);
    if (widget.initialPresenceByPlaceId == null &&
        widget.getPresenceForDate != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _loadPresenceForDate(_selectedDate),
      );
    }
  }

  Future<void> _loadPresenceForDate(DateTime date) async {
    final getPresence = widget.getPresenceForDate;
    if (getPresence == null || !mounted) return;
    setState(() => _loadingPresence = true);
    try {
      final map = await getPresence(date);
      if (mounted) {
        setState(() {
          _presenceByPlaceId = buildPresenceMap(widget.places, map);
          _loadingPresence = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPresence = false);
    }
  }

  Future<void> _onChangeDateTap() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 1),
      lastDate: DateTime(_selectedDate.year + 1),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
      await _loadPresenceForDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ManualAttendanceSheetContent(
      theme: theme,
      isDark: isDark,
      selectedDate: _selectedDate,
      onChangeDateTap: _onChangeDateTap,
      places: widget.places,
      presenceByPlaceId: _presenceByPlaceId,
      loading: _loadingPresence,
      onPresenceChanged: (placeId, value) {
        setState(() => _presenceByPlaceId[placeId] = value);
      },
      onApply: () {
        widget.onApply?.call(_selectedDate, Map.from(_presenceByPlaceId));
        context.pop();
      },
      onCancel: () {
        widget.onCancel?.call();
        context.pop();
      },
    );
  }
}
