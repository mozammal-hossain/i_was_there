import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../domain/places/use_cases/get_places_use_case.dart';
import '../domain/presence/use_cases/get_aggregated_presence_use_case.dart';
import '../domain/presence/use_cases/get_presences_for_day_use_case.dart';
import '../domain/presence/use_cases/set_presence_use_case.dart';
import 'history/bloc/calendar_bloc.dart';
import 'history/bloc/calendar_event.dart';
import 'history/bloc/calendar_state.dart';
import 'history/history_page.dart';
import 'manual_attendance/manual_attendance_page.dart';

/// Calendar feature: presence history and manual attendance override.
class CalendarFeature extends StatelessWidget {
  const CalendarFeature({super.key});

  CalendarBloc _createCalendarBloc() {
    return CalendarBloc(
      getPlaces: getIt<GetPlacesUseCase>(),
      getAggregatedPresence: getIt<GetAggregatedPresenceUseCase>(),
      getPresencesForDay: getIt<GetPresencesForDayUseCase>(),
      setPresence: getIt<SetPresenceUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createCalendarBloc()..add(CalendarLoadRequested()),
      child: BlocConsumer<CalendarBloc, CalendarState>(
        listenWhen: (prev, curr) => curr.errorMessage != prev.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (prev, curr) =>
            prev.loadingPlaces != curr.loadingPlaces ||
            prev.places != curr.places ||
            prev.presenceByDay != curr.presenceByDay ||
            prev.loadingPresence != curr.loadingPresence ||
            prev.selectedDay != curr.selectedDay ||
            prev.dayPresences != curr.dayPresences ||
            prev.loadingDayDetails != curr.loadingDayDetails,
        builder: (context, state) {
          if (state.loadingPlaces) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return HistoryPage(
            places: state.places,
            viewMonth: state.effectiveViewMonth,
            presenceByDay: state.presenceByDay,
            loadingPresence: state.loadingPresence,
            selectedDay: state.selectedDay,
            dayPresences: state.dayPresences,
            loadingDayDetails: state.loadingDayDetails,
            onMonthChanged: (month) =>
                context.read<CalendarBloc>().add(CalendarMonthChanged(month)),
            onDaySelected: (day) =>
                context.read<CalendarBloc>().add(CalendarDaySelected(day)),
            onAddManual: () => _openManualAttendance(context),
          );
        },
      ),
    );
  }

  void _openManualAttendance(BuildContext context) {
    final state = context.read<CalendarBloc>().state;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ManualAttendancePage(
        places: state.places,
        onApply: (date, presence) async {
          context.read<CalendarBloc>().add(
                CalendarManualPresenceApplied(date, presence),
              );
          if (ctx.mounted) {
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text('Manual presence updated')),
            );
          }
        },
      ),
    );
  }
}
