import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../domain/places/entities/place.dart';
import '../../domain/places/use_cases/add_place.dart';
import '../../domain/places/use_cases/get_places.dart';
import '../../domain/places/use_cases/remove_place.dart';
import '../../domain/places/use_cases/update_place.dart';
import '../../domain/presence/entities/presence.dart';
import '../../domain/presence/use_cases/set_presence.dart';
import '../calendar/widgets/manual_attendance_screen.dart';
import 'bloc/places_bloc.dart';
import 'bloc/places_event.dart';
import 'bloc/places_state.dart';
import 'widgets/dashboard_screen.dart';
import 'widgets/map_screen.dart';
import 'widgets/no_place_screen.dart';

/// Places feature: list of places, map, add/edit. Only place-related screens.
class PlacesFeature extends StatelessWidget {
  const PlacesFeature({super.key});

  PlacesBloc _createPlacesBloc() {
    return PlacesBloc(
      getPlaces: getIt<GetPlaces>(),
      addPlace: getIt<AddPlace>(),
      updatePlace: getIt<UpdatePlace>(),
      removePlace: getIt<RemovePlace>(),
    );
  }

  Future<void> _applyManualPresence(
    DateTime date,
    Map<String, bool> presence,
  ) async {
    final setPresence = getIt<SetPresence>();
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
      create: (_) => _createPlacesBloc()..add(PlacesLoadRequested()),
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
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlacesBloc, PlacesState>(
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
          return NoPlaceScreen(onAddPlace: () => _openAddPlace(context));
        }
        switch (_navIndex) {
          case 1:
            return MapScreen(
              places: state.places,
              onBack: () => setState(() => _navIndex = 0),
            );
          default:
            return DashboardScreen(
              places: state.places,
              onAddPlace: () => _openAddPlace(context),
              onPlaceTap: (place) => _openEditPlace(context, place),
              onManualOverride: () =>
                  _openManualAttendance(context, state.places),
              currentNavIndex: _navIndex,
              onNavTap: (index) => setState(() => _navIndex = index),
              placesOnlyNav: true,
            );
        }
      },
    );
  }

  void _openManualAttendance(BuildContext context, List<Place> places) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManualAttendanceScreen(
        places: places,
        onApply: (date, presence) async {
          await widget.onManualApply(date, presence);
          if (context.mounted) {
            context.read<PlacesBloc>().add(PlacesLoadRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Manual presence updated')),
            );
          }
        },
      ),
    );
  }

  void _openAddPlace(BuildContext context) {
    final bloc = context.read<PlacesBloc>();
    context.push<void>(
      '/places/add',
      extra: AddEditPlaceExtra(placesBloc: bloc),
    );
  }

  void _openEditPlace(BuildContext context, Place place) {
    final bloc = context.read<PlacesBloc>();
    context.push<void>(
      '/places/edit/${place.id}',
      extra: AddEditPlaceExtra(placesBloc: bloc, place: place),
    );
  }
}
