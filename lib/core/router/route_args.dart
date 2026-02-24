import '../../domain/places/entities/place.dart';
import '../../presentation/dashboard/bloc/dashboard_bloc.dart';

/// Route arguments for add/edit place screens.
/// Pass Bloc and optional [place] through the router (state.extra).
/// When a route needs 3 or more values, use a dedicated model like this.
class AddEditPlaceRouteArgs {
  const AddEditPlaceRouteArgs({required this.dashboardBloc, this.place});

  final DashboardBloc dashboardBloc;
  final Place? place;
}
