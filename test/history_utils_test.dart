import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_was_there/presentation/history/utils/history_utils.dart';

void main() {
  testWidgets('HistoryMonthName localized respects locale', (tester) async {
    final date = DateTime(2025, 4, 1);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            final name = historyMonthName(date, context);
            expect(name.toLowerCase(), contains('april'));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  testWidgets('First weekday respects firstDayOfWeekIndex', (tester) async {
    final date = DateTime(2025, 6, 1); // June 1 2025 is a Sunday
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            final offset = historyFirstWeekdayOfMonth(date, context);
            // for default (Sunday first) offset should be 0
            expect(offset, 0);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
