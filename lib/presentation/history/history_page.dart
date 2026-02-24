import 'package:flutter/material.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
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
    this.loadingPresence = false,
    this.selectedDay,
    this.dayPresences = const [],
    this.loadingDayDetails = false,
    this.selectedPlaceId,
    this.onBack,
    this.onMonthChanged,
    this.onDaySelected,
    this.onFilterChanged,
    this.onAddManual,
  });

  final List<Place> places;
  final DateTime viewMonth;
  final Map<DateTime, bool> presenceByDay;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final String? selectedPlaceId;
  final VoidCallback? onBack;
  final void Function(DateTime month)? onMonthChanged;
  final void Function(int? day)? onDaySelected;
  final void Function(String? placeId)? onFilterChanged;
  final VoidCallback? onAddManual;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> get _filterLabels => [
        'All Places',
        ...widget.places.map((p) => p.name),
      ];

  int get _selectedFilterIndex {
    final id = widget.selectedPlaceId;
    if (id == null) return 0;
    final i = widget.places.indexWhere((p) => p.id == id);
    return i < 0 ? 0 : i + 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HistoryHeader(onBack: widget.onBack, isDark: isDark),
            HistoryFilterChips(
              labels: _filterLabels,
              selectedIndex: _selectedFilterIndex.clamp(
                0,
                _filterLabels.length - 1,
              ),
              isDark: isDark,
              onSelected: (i) {
                final placeId =
                    i == 0 ? null : widget.places[i - 1].id;
                widget.onFilterChanged?.call(placeId);
              },
            ),
            Expanded(
              child: HistoryPageContent(
                viewMonth: widget.viewMonth,
                presenceByDay: widget.presenceByDay,
                loadingPresence: widget.loadingPresence,
                selectedDay: widget.selectedDay,
                dayPresences: widget.dayPresences,
                loadingDayDetails: widget.loadingDayDetails,
                places: widget.places,
                theme: theme,
                isDark: isDark,
                onMonthChanged: widget.onMonthChanged ?? (_) {},
                onDaySelected: widget.onDaySelected ?? (_) {},
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.onAddManual != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: FloatingActionButton(
                onPressed: widget.onAddManual,
                child: const Icon(Icons.add, size: 28),
              ),
            )
          : null,
    );
  }
}
