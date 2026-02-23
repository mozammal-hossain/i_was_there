import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:i_was_there/core/di/injection.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/presentation/main_shell.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Calendar page', () {
    setUpAll(() {
      configureDependencies();
    });

    /// Pumps the main app shell (Places / Calendar / Settings) and waits for it to settle.
    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(isDark: false),
          darkTheme: buildAppTheme(isDark: true),
          home: const MainShell(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 10));
    }

    /// Opens the Calendar tab from the bottom nav. Call after [pumpApp].
    Future<void> openCalendarTab(WidgetTester tester) async {
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens from bottom nav and shows presence history', (tester) async {
      await pumpApp(tester);
      await openCalendarTab(tester);

      expect(find.text('Presence History'), findsOneWidget);
      expect(find.text('All Places'), findsOneWidget);
    });

    testWidgets('shows month navigation and day details placeholder', (tester) async {
      await pumpApp(tester);
      await openCalendarTab(tester);

      expect(find.byType(IconButton), findsWidgets);
      expect(find.text('Tap a day on the calendar to see sessions'), findsOneWidget);
    });

    testWidgets('navigates to previous and next month', (tester) async {
      await pumpApp(tester);
      await openCalendarTab(tester);

      final leftButtons = find.widgetWithIcon(IconButton, Icons.chevron_left);
      final rightButtons = find.widgetWithIcon(IconButton, Icons.chevron_right);
      expect(leftButtons, findsWidgets);
      expect(rightButtons, findsWidgets);

      await tester.tap(rightButtons.first);
      await tester.pumpAndSettle();

      await tester.tap(leftButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Presence History'), findsOneWidget);
    });

    testWidgets('selecting a day shows day details section', (tester) async {
      await pumpApp(tester);
      await openCalendarTab(tester);

      final day15 = find.text('15');
      if (day15.evaluate().isNotEmpty) {
        await tester.tap(day15.first);
        await tester.pumpAndSettle();
        expect(find.textContaining('DAY DETAILS'), findsOneWidget);
      }
    });

    testWidgets('manual attendance FAB is tappable', (tester) async {
      await pumpApp(tester);
      await openCalendarTab(tester);

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
