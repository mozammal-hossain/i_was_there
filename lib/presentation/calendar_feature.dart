import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../l10n/app_localizations.dart';
import '../domain/places/use_cases/get_places_use_case.dart';
import '../domain/presence/use_cases/get_presence_for_month_use_case.dart';
import '../domain/presence/use_cases/get_presences_for_day_use_case.dart';
import '../domain/presence/use_cases/set_presence_use_case.dart';
import 'history/bloc/history_bloc.dart';
import 'history/bloc/history_event.dart';
import 'history/bloc/history_state.dart';
import 'history/history_page.dart';
import 'manual_attendance/manual_attendance_page.dart';

/// Calendar feature: presence history and manual attendance override.
class CalendarFeature extends StatelessWidget {
  const CalendarFeature({super.key});

  HistoryBloc _createHistoryBloc() {
    return HistoryBloc(
      getPlaces: getIt<GetPlacesUseCase>(),
      getPresenceForMonth: getIt<GetPresenceForMonthUseCase>(),
      getPresencesForDay: getIt<GetPresencesForDayUseCase>(),
      setPresence: getIt<SetPresenceUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createHistoryBloc()..add(HistoryLoadRequested()),
      child: BlocConsumer<HistoryBloc, HistoryState>(
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
            prev.presenceByDayPerPlace != curr.presenceByDayPerPlace ||
            prev.presenceByDay != curr.presenceByDay ||
            prev.loadingPresence != curr.loadingPresence ||
            prev.selectedDay != curr.selectedDay ||
            prev.dayPresences != curr.dayPresences ||
            prev.loadingDayDetails != curr.loadingDayDetails ||
            prev.selectedPlaceId != curr.selectedPlaceId,
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
            presenceByDayPerPlace: state.presenceByDayPerPlace,
            loadingPresence: state.loadingPresence,
            selectedDay: state.selectedDay,
            dayPresences: state.dayPresences,
            loadingDayDetails: state.loadingDayDetails,
            selectedPlaceId: state.selectedPlaceId,
            onFilterChanged: (placeId) =>
                context.read<HistoryBloc>().add(HistoryFilterChanged(placeId)),
            onMonthChanged: (month) =>
                context.read<HistoryBloc>().add(HistoryMonthChanged(month)),
            onDaySelected: (day) =>
                context.read<HistoryBloc>().add(HistoryDaySelected(day)),
            onDayEdit: (date) => _openManualAttendance(context, date),
            onAddManual: () => _openManualAttendance(context),
          );
        },
      ),
    );
  }

  void _openManualAttendance(BuildContext context, [DateTime? forcedDate]) {
    final state = context.read<HistoryBloc>().state;
    final effectiveMonth = state.effectiveViewMonth;
    final initialDate =
        forcedDate ??
        (state.selectedDay != null
            ? DateTime(
                effectiveMonth.year,
                effectiveMonth.month,
                state.selectedDay!,
              )
            : DateTime.now());
    final initialPresenceByPlaceId =
        state.selectedDay != null || forcedDate != null
        ? {
            for (final p in state.places)
              p.id: state.dayPresences.any(
                (d) => d.placeId == p.id && d.isPresent,
              ),
          }
        : null;
    final getPresencesForDay = getIt<GetPresencesForDayUseCase>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ManualAttendancePage(
        places: state.places,
        initialDate: initialDate,
        initialPresenceByPlaceId: initialPresenceByPlaceId,
        getPresenceForDate: (date) async {
          final list = await getPresencesForDay.call(date);
          return {
            for (final p in state.places)
              p.id: list.any((e) => e.placeId == p.id && e.isPresent),
          };
        },
        onApply: (date, presence) async {
          context.read<HistoryBloc>().add(
            HistoryManualPresenceApplied(date, presence),
          );
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.manualPresenceUpdated,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
