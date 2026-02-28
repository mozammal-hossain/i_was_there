import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../l10n/app_localizations.dart';
import '../core/router/app_routes.dart';
import '../core/router/route_args.dart';
import '../domain/places/entities/place.dart';
import '../domain/places/use_cases/add_place_use_case.dart';
import '../domain/places/use_cases/get_places_use_case.dart';
import '../domain/places/use_cases/remove_place_use_case.dart';
import '../domain/places/use_cases/update_place_use_case.dart';
import '../domain/presence/entities/presence.dart';
import '../domain/presence/use_cases/get_presences_for_day_use_case.dart';
import '../domain/presence/use_cases/set_presence_use_case.dart';
import 'manual_attendance/manual_attendance_page.dart';
import 'dashboard/bloc/dashboard_bloc.dart';
import 'dashboard/bloc/dashboard_event.dart';
import 'dashboard/bloc/dashboard_state.dart';
import 'dashboard/dashboard_page.dart';
import 'no_place/no_place_page.dart';

/// Places feature: list of places, add/edit. Only place-related pages.
class PlacesFeature extends StatelessWidget {
  const PlacesFeature({super.key});

  DashboardBloc _createDashboardBloc() {
    return DashboardBloc(
      getPlaces: getIt<GetPlacesUseCase>(),
      addPlace: getIt<AddPlaceUseCase>(),
      updatePlace: getIt<UpdatePlaceUseCase>(),
      removePlace: getIt<RemovePlaceUseCase>(),
    );
  }

  Future<void> _applyManualPresence(
    DateTime date,
    Map<String, bool> presence,
  ) async {
    final setPresence = getIt<SetPresenceUseCase>();
    for (final entry in presence.entries) {
      await setPresence.call(
        placeId: entry.key,
        date: date,
        isPresent: entry.value,
        source: PresenceSource.manual,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createDashboardBloc()..add(DashboardLoadRequested()),
      child: _PlacesShell(onManualApply: _applyManualPresence),
    );
  }
}

class _PlacesShell extends StatefulWidget {
  const _PlacesShell({required this.onManualApply});

  final Future<void> Function(DateTime date, Map<String, bool> presence)
  onManualApply;

  @override
  State<_PlacesShell> createState() => _PlacesShellState();
}

class _PlacesShellState extends State<_PlacesShell> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listenWhen: (prev, curr) => curr.errorMessage != null,
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
      buildWhen: (prev, curr) => prev.places != curr.places,
      builder: (context, state) {
        if (!state.hasPlaces) {
          return NoPlacePage(onAddPlace: () => _openAddPlace(context));
        }
        return DashboardPage(
          places: state.places,
          onAddPlace: () => _openAddPlace(context),
          onPlaceTap: (place) => _openEditPlace(context, place),
          onManualOverride: () =>
              _openManualAttendance(context, state.places),
          placesOnlyNav: true,
        );
      },
    );
  }

  void _openManualAttendance(BuildContext context, List<Place> places) {
    final getPresencesForDay = getIt<GetPresencesForDayUseCase>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManualAttendancePage(
        places: places,
        initialDate: DateTime.now(),
        getPresenceForDate: (date) async {
          final list = await getPresencesForDay.call(date);
          return {
            for (final p in places)
              p.id: list.any((e) => e.placeId == p.id && e.isPresent),
          };
        },
        onApply: (date, presence) async {
          await widget.onManualApply(date, presence);
          if (context.mounted) {
            context.read<DashboardBloc>().add(DashboardLoadRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.manualPresenceUpdated)),
            );
          }
        },
      ),
    );
  }

  void _openAddPlace(BuildContext context) {
    final bloc = context.read<DashboardBloc>();
    context.push<void>(
      AppRoutes.placeAdd,
      extra: AddEditPlaceRouteArgs(dashboardBloc: bloc),
    );
  }

  void _openEditPlace(BuildContext context, Place place) {
    final bloc = context.read<DashboardBloc>();
    context.push<void>(
      AppRoutes.placeEdit(place.id),
      extra: AddEditPlaceRouteArgs(dashboardBloc: bloc, place: place),
    );
  }
}
