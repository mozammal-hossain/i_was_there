import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/settings/repositories/settings_repository.dart';
import 'package:i_was_there/domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import 'package:i_was_there/domain/settings/use_cases/get_last_sync_time_use_case.dart';
import 'package:i_was_there/domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import 'package:i_was_there/l10n/app_localizations.dart';
import 'package:i_was_there/presentation/settings/bloc/settings_bloc.dart';
import 'package:i_was_there/presentation/settings/bloc/settings_event.dart';
import 'package:i_was_there/presentation/settings/bloc/settings_state.dart';
import 'package:i_was_there/presentation/settings/settings_page.dart';

void main() {
  group('SettingsPage widget test', () {
    late FakeSettingsRepository fakeRepo;
    late GetCalendarSyncEnabledUseCase getSyncUseCase;
    late SetCalendarSyncEnabledUseCase setSyncUseCase;
    late GetLastSyncTimeUseCase getLastSyncTimeUseCase;

    setUp(() {
      fakeRepo = FakeSettingsRepository();
      getSyncUseCase = GetCalendarSyncEnabledUseCase(fakeRepo);
      setSyncUseCase = SetCalendarSyncEnabledUseCase(fakeRepo);
      getLastSyncTimeUseCase = GetLastSyncTimeUseCase(fakeRepo);
    });

    Widget buildTestWidget({required SettingsBloc bloc}) {
      return MaterialApp(
        theme: buildAppTheme(isDark: false),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SettingsBloc>.value(
          value: bloc,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return SettingsPage(
                syncEnabled: state.syncEnabled,
                loading: state.loading,
                lastSyncTime: state.lastSyncTime,
                onSyncEnabledChanged: (value) =>
                    context.read<SettingsBloc>().add(
                          SettingsSyncEnabledChanged(value),
                        ),
              );
            },
          ),
        ),
      );
    }

    testWidgets('shows Sync with Google Calendar section',
        (WidgetTester tester) async {
      final bloc = SettingsBloc(
        getCalendarSyncEnabled: getSyncUseCase,
        setCalendarSyncEnabled: setSyncUseCase,
        getLastSyncTime: getLastSyncTimeUseCase,
      )..add(SettingsLoadRequested());

      await tester.pumpWidget(buildTestWidget(bloc: bloc));
      await tester.pumpAndSettle();

      expect(find.text('Sync with Google Calendar'), findsOneWidget);
    });

    testWidgets('shows sync toggle and connected account content',
        (WidgetTester tester) async {
      final bloc = SettingsBloc(
        getCalendarSyncEnabled: getSyncUseCase,
        setCalendarSyncEnabled: setSyncUseCase,
        getLastSyncTime: getLastSyncTimeUseCase,
      )..add(SettingsLoadRequested());

      await tester.pumpWidget(buildTestWidget(bloc: bloc));
      await tester.pumpAndSettle();

      expect(find.text('Automatic attendance logging'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows Language section', (WidgetTester tester) async {
      final bloc = SettingsBloc(
        getCalendarSyncEnabled: getSyncUseCase,
        setCalendarSyncEnabled: setSyncUseCase,
        getLastSyncTime: getLastSyncTimeUseCase,
      )..add(SettingsLoadRequested());

      await tester.pumpWidget(buildTestWidget(bloc: bloc));
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
    });
  });
}

class FakeSettingsRepository implements SettingsRepository {
  bool syncEnabled = false;
  String? localeLanguageCode;

  @override
  Future<bool> getCalendarSyncEnabled() async => syncEnabled;

  @override
  Future<void> setCalendarSyncEnabled(bool enabled) async {
    syncEnabled = enabled;
  }

  @override
  Future<String?> getLocaleLanguageCode() async => localeLanguageCode;

  @override
  Future<void> setLocaleLanguageCode(String languageCode) async {
    localeLanguageCode = languageCode;
  }

  DateTime? _lastSyncTime;

  @override
  Future<DateTime?> getLastSyncTime() async => _lastSyncTime;

  @override
  Future<void> setLastSyncTime(DateTime time) async {
    _lastSyncTime = time;
  }
}
