import 'package:flutter/material.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/dashboard/widgets/dashboard_place_card.dart';

/// "TRACKED STUDIOS" label and list of [DashboardPlaceCard]s.
class DashboardPlaceListSection extends StatelessWidget {
  const DashboardPlaceListSection({
    super.key,
    required this.places,
    required this.isDark,
    required this.onPlaceTap,
  });

  final List<Place> places;
  final bool isDark;
  final void Function(Place place) onPlaceTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final place = places[index];
          return DashboardPlaceCard(
            place: place,
            isDark: isDark,
            onTap: () => onPlaceTap(place),
          );
        }, childCount: places.length),
      ),
    );
  }
}
