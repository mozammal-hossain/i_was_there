import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/domain/presence/entities/presence.dart';
import 'package:i_was_there/presentation/history/utils/history_utils.dart';
import 'package:i_was_there/presentation/history/widgets/history_calendar_grid.dart';
import 'package:i_was_there/presentation/history/widgets/history_day_details_section.dart';
import 'package:i_was_there/presentation/history/widgets/history_month_nav.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

/// Scrollable content for [HistoryPage]: month nav, calendar grid, day details.
class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({
    super.key,
    required this.viewMonth,
    required this.presenceByDay,
    required this.presenceByDayPerPlace,
    required this.selectedPlaceId,
    required this.placeColors,
    required this.loadingPresence,
    required this.selectedDay,
    required this.dayPresences,
    required this.loadingDayDetails,
    required this.places,
    required this.theme,
    required this.isDark,
    required this.onMonthChanged,
    required this.onDaySelected,
    this.onDayEdit,
  });

  final DateTime viewMonth;
  final Map<DateTime, bool> presenceByDay;
  final Map<DateTime, Map<String, bool>> presenceByDayPerPlace;
  final String? selectedPlaceId;
  final Map<String, Color> placeColors;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final List<Place> places;
  final ThemeData theme;
  final bool isDark;
  final void Function(DateTime month) onMonthChanged;
  final void Function(int? day) onDaySelected;
  final void Function(DateTime date)? onDayEdit;

  int get _daysInMonth => historyDaysInMonth(viewMonth.year, viewMonth.month);

  int _firstWeekday(BuildContext context) =>
      historyFirstWeekdayOfMonth(viewMonth, context);

  int? get _effectiveSelectedDay {
    if (selectedDay == null) return null;
    if (selectedDay! < 1 || selectedDay! > _daysInMonth) return null;
    return selectedDay;
  }

  bool _hasPresence(int day) {
    final d = DateTime(viewMonth.year, viewMonth.month, day);
    // presenceByDay is already computed considering selectedPlaceId filter
    return presenceByDay[d] ?? false;
  }

  void _handleDayLongPress(BuildContext context, int day) {
    final date = DateTime(viewMonth.year, viewMonth.month, day);
    final segments = presenceByDayPerPlace[date] ?? {};
    final presentIds = segments.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSize.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                )!.dayDetailsTitle(historyMonthName(viewMonth, context), day),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSize.spacingM),
              if (presentIds.isEmpty)
                Text(AppLocalizations.of(context)!.noSessions)
              else
                ...presentIds.map((id) {
                  final place = places.firstWhere(
                    (p) => p.id == id,
                    orElse: () => Place(
                      id: id,
                      name: id,
                      address: '',
                      latitude: 0,
                      longitude: 0,
                    ),
                  );
                  return Text(place.name);
                }),
              const SizedBox(height: AppSize.spacingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  if (onDayEdit != null) ...[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        onDayEdit!(date);
                      },
                      child: Text(AppLocalizations.of(context)!.enterPlaceName),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final presentCount = presenceByDay.values.where((v) => v).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.spacingL,
        vertical: AppSize.spacingXl,
      ),
      child: Column(
        children: [
          HistoryMonthNav(
            viewMonth: viewMonth,
            theme: theme,
            isDark: isDark,
            totalPresent: presentCount,
            onPrev: () =>
                onMonthChanged(DateTime(viewMonth.year, viewMonth.month - 1)),
            onNext: () =>
                onMonthChanged(DateTime(viewMonth.year, viewMonth.month + 1)),
          ),
          const SizedBox(height: AppSize.spacingL),
          if (loadingPresence)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.spacingXl),
                child: SizedBox(
                  width: AppSize.iconL,
                  height: AppSize.iconL,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSize.spacingXs,
                  ),
                ),
              ),
            )
          else
            HistoryCalendarGrid(
              viewMonth: viewMonth,
              daysInMonth: _daysInMonth,
              firstWeekday: _firstWeekday(context),
              presenceByDayPerPlace: presenceByDayPerPlace,
              hasPresence: _hasPresence,
              isToday: (day) => historyIsToday(viewMonth, day),
              selectedDay: _effectiveSelectedDay,
              theme: theme,
              isDark: isDark,
              onDayTap: onDaySelected,
              onDayLongPress: (day) => _handleDayLongPress(context, day),
              selectedPlaceId: selectedPlaceId,
              placeColors: placeColors,
            ),
          const SizedBox(height: AppSize.spacingXl4),
          HistoryDayDetailsSection(
            viewMonth: viewMonth,
            selectedDay: _effectiveSelectedDay,
            dayPresences: _effectiveSelectedDay != null
                ? dayPresences
                : const [],
            loadingDayDetails: _effectiveSelectedDay != null
                ? loadingDayDetails
                : false,
            places: places,
            theme: theme,
            isDark: isDark,
            monthName: historyMonthName(viewMonth, context),
          ),
        ],
      ),
    );
  }
}
