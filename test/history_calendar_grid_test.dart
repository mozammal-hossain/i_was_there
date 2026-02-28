import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_was_there/presentation/history/widgets/history_calendar_grid.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

void main() {
  testWidgets('Calendar grid shows colored segments for multiple places', (
    WidgetTester tester,
  ) async {
    final viewMonth = DateTime(2025, 2, 1);
    // February with 28 days; first weekday assume Sunday offset 0 for simplicity.
    final presenceByDayPerPlace = <DateTime, Map<String, bool>>{};
    for (var d = 1; d <= 28; d++) {
      final date = DateTime(2025, 2, d);
      presenceByDayPerPlace[date] = {
        'a': d % 2 == 0,
        'b': d % 3 == 0,
        'c': false,
      };
    }
    bool hasPresence(int day) {
      final date = DateTime(viewMonth.year, viewMonth.month, day);
      final segments = presenceByDayPerPlace[date] ?? {};
      return segments.values.any((v) => v);
    }

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return HistoryCalendarGrid(
              viewMonth: viewMonth,
              daysInMonth: 28,
              firstWeekday: 0,
              presenceByDayPerPlace: presenceByDayPerPlace,
              hasPresence: hasPresence,
              isToday: (_) => false,
              selectedDay: null,
              theme: Theme.of(context),
              isDark: false,
              onDayTap: (_) {},
              placeColors: {'a': Colors.red, 'b': Colors.blue},
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // ensure at least one day cell is rendered
    expect(find.text('1'), findsWidgets);
  });
}
