import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/l10n/app_localizations.dart';
import 'package:i_was_there/domain/presence/entities/presence.dart';
import 'package:i_was_there/presentation/history/widgets/history_filter_chips.dart';
import 'package:i_was_there/presentation/history/widgets/history_header.dart';
import 'package:i_was_there/presentation/history/widgets/history_page_content.dart';

/// Presence history calendar. Month view, filter chips, day details.
/// All data and loading state come from [HistoryBloc]; this page only renders and dispatches events.
class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    this.places = const [],
    required this.viewMonth,
    this.presenceByDay = const {},
    this.presenceByDayPerPlace = const {},
    this.loadingPresence = false,
    this.selectedDay,
    this.dayPresences = const [],
    this.loadingDayDetails = false,
    this.selectedPlaceId,
    this.onBack,
    this.onMonthChanged,
    this.onDaySelected,
    this.onFilterChanged,
    this.onDayEdit,
    this.onAddManual,
  });

  final List<Place> places;
  final DateTime viewMonth;
  final Map<DateTime, bool> presenceByDay;
  final Map<DateTime, Map<String, bool>> presenceByDayPerPlace;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final String? selectedPlaceId;
  final VoidCallback? onBack;
  final void Function(DateTime month)? onMonthChanged;
  final void Function(int? day)? onDaySelected;
  final void Function(String? placeId)? onFilterChanged;
  final void Function(DateTime date)? onDayEdit;
  final VoidCallback? onAddManual;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _filterLabels(BuildContext context) => [
    AppLocalizations.of(context)!.allPlaces,
    ...widget.places.map((p) => p.name),
  ];

  int _selectedFilterIndex(List<String> labels) {
    final id = widget.selectedPlaceId;
    if (id == null) return 0;
    final i = widget.places.indexWhere((p) => p.id == id);
    return i < 0 ? 0 : i + 1;
  }

  Map<String, Color> get _placeColors {
    const palette = [
      AppColors.primary,
      AppColors.success,
      AppColors.error,
      AppColors.primaryLight,
      AppColors.primaryTint,
    ];
    final map = <String, Color>{};
    for (var i = 0; i < widget.places.length; i++) {
      map[widget.places[i].id] =
          palette[i % palette.length]; // deterministic by index
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filterLabels = _filterLabels(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HistoryHeader(onBack: widget.onBack, isDark: isDark),
            HistoryFilterChips(
              labels: filterLabels,
              selectedIndex: _selectedFilterIndex(
                filterLabels,
              ).clamp(0, filterLabels.length - 1),
              isDark: isDark,
              onSelected: (i) {
                final placeId = i == 0 ? null : widget.places[i - 1].id;
                widget.onFilterChanged?.call(placeId);
              },
            ),
            if (widget.places.isNotEmpty) ...[
              const SizedBox(height: AppSize.spacingS),
              Wrap(
                spacing: AppSize.spacingS,
                runSpacing: AppSize.spacingXs,
                children: widget.places.map((p) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: AppSize.spacingS2,
                        height: AppSize.spacingS2,
                        decoration: BoxDecoration(
                          color: _placeColors[p.id],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSize.spacingXs),
                      Text(p.name, style: theme.textTheme.labelSmall),
                    ],
                  );
                }).toList(),
              ),
            ],
            Expanded(
              child: HistoryPageContent(
                viewMonth: widget.viewMonth,
                presenceByDay: widget.presenceByDay,
                presenceByDayPerPlace: widget.presenceByDayPerPlace,
                loadingPresence: widget.loadingPresence,
                selectedDay: widget.selectedDay,
                dayPresences: widget.dayPresences,
                loadingDayDetails: widget.loadingDayDetails,
                places: widget.places,
                theme: theme,
                isDark: isDark,
                selectedPlaceId: widget.selectedPlaceId,
                placeColors: _placeColors,
                onMonthChanged: widget.onMonthChanged ?? (_) {},
                onDaySelected: widget.onDaySelected ?? (_) {},
                onDayEdit: widget.onDayEdit,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.onAddManual != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: AppSize.spacingXl8),
              child: FloatingActionButton(
                heroTag: 'history_fab',
                onPressed: widget.onAddManual,
                child: const Icon(Icons.add, size: AppSize.iconL3),
              ),
            )
          : null,
    );
  }
}
