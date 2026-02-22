import '../../../../domain/places/entities/place.dart';

abstract class DashboardEvent {}

class DashboardLoadRequested extends DashboardEvent {}

class DashboardAddRequested extends DashboardEvent {
  DashboardAddRequested(this.place);
  final Place place;
}

class DashboardUpdateRequested extends DashboardEvent {
  DashboardUpdateRequested(this.place);
  final Place place;
}

class DashboardRemoveRequested extends DashboardEvent {
  DashboardRemoveRequested(this.id);
  final String id;
}
