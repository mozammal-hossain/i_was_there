import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../domain/places/entities/place.dart';
import '../../domain/presence/entities/presence.dart';
import '../../domain/places/use_cases/get_places.dart';
import '../../domain/presence/use_cases/get_aggregated_presence.dart';
import '../../domain/presence/use_cases/get_presences_for_day.dart';
import '../../domain/presence/use_cases/set_presence.dart';
import 'widgets/history_screen.dart';
import 'widgets/manual_attendance_screen.dart';

/// Calendar feature: presence history and manual attendance override.
class CalendarFeature extends StatefulWidget {
  const CalendarFeature({super.key});

  @override
  State<CalendarFeature> createState() => _CalendarFeatureState();
}

class _CalendarFeatureState extends State<CalendarFeature> {
  late final GetPlaces _getPlaces;
  late final GetAggregatedPresence _getAggregatedPresence;
  late final GetPresencesForDay _getPresencesForDay;
  late final SetPresence _setPresence;
  List<Place> _places = [];
  bool _loadingPlaces = true;

  @override
  void initState() {
    super.initState();
    _getPlaces = getIt<GetPlaces>();
    _getAggregatedPresence = getIt<GetAggregatedPresence>();
    _getPresencesForDay = getIt<GetPresencesForDay>();
    _setPresence = getIt<SetPresence>();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final list = await _getPlaces.call();
    if (mounted) {
      setState(() {
        _places = list;
        _loadingPlaces = false;
      });
    }
  }

  Future<void> _applyManualPresence(DateTime date, Map<String, bool> presence) async {
    for (final entry in presence.entries) {
      await _setPresence.call(
        placeId: entry.key,
        date: date,
        isPresent: entry.value,
        source: PresenceSource.manual,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Manual presence updated')),
      );
    }
  }

  void _openManualAttendance() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManualAttendanceScreen(
        places: _places,
        onApply: (date, presence) async {
          await _applyManualPresence(date, presence);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPlaces) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return HistoryScreen(
      places: _places,
      onAddManual: _openManualAttendance,
      getAggregatedPresence: _getAggregatedPresence,
      getPresencesForDay: _getPresencesForDay,
    );
  }
}
