import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/di/injection.dart';
import '../../domain/location/location_service.dart';
import '../../domain/location/use_cases/get_current_location_with_address_use_case.dart';
import '../../domain/location/use_cases/get_location_from_address_use_case.dart';
import '../../domain/location/use_cases/get_location_from_coordinates_use_case.dart';
import '../background_location/background_location_page.dart';
import '../dashboard/bloc/dashboard_event.dart';
import 'add_edit_place_page.dart';
import 'bloc/add_edit_place_bloc.dart';
import '../../core/router/route_args.dart';

/// Gate for the add-place flow: shows background location permission screen
/// if not already granted, then the add-place page. Edit place is not gated.
class AddPlacePermissionGate extends StatefulWidget {
  const AddPlacePermissionGate({super.key, required this.args});

  final AddEditPlaceRouteArgs args;

  @override
  State<AddPlacePermissionGate> createState() => _AddPlacePermissionGateState();
}

class _AddPlacePermissionGateState extends State<AddPlacePermissionGate>
    with WidgetsBindingObserver {
  bool _permissionChecked = false;
  bool _hasBackgroundLocation = false;
  bool _showAddPlace = false;

  LocationService get _locationService => getIt<LocationService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAfterResume();
    }
  }

  Future<void> _checkPermission() async {
    final has = await _locationService.hasBackgroundLocationPermission();
    if (!mounted) return;
    setState(() {
      _permissionChecked = true;
      _hasBackgroundLocation = has;
      _showAddPlace = has;
    });
  }

  Future<void> _checkPermissionAfterResume() async {
    final has = await _locationService.hasBackgroundLocationPermission();
    if (!mounted) return;
    setState(() {
      _hasBackgroundLocation = has;
      if (has) _showAddPlace = true;
    });
  }

  void _onOpenSettings() {
    Geolocator.openAppSettings();
  }

  void _onLater() {
    setState(() => _showAddPlace = true);
  }

  void _onBack() {
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionChecked) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showAddPlace || _hasBackgroundLocation) {
      return BlocProvider.value(
        value: widget.args.dashboardBloc,
        child: BlocProvider(
          create: (_) => AddEditPlaceBloc(
            getIt<GetCurrentLocationWithAddressUseCase>(),
            getIt<GetLocationFromAddressUseCase>(),
            getIt<GetLocationFromCoordinatesUseCase>(),
          ),
          child: AddEditPlacePage(
            onSave: (place) =>
                widget.args.dashboardBloc.add(DashboardAddRequested(place)),
          ),
        ),
      );
    }

    return BackgroundLocationPage(
      onOpenSettings: _onOpenSettings,
      onLater: _onLater,
      onBack: _onBack,
    );
  }
}
