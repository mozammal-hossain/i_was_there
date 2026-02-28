import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/settings/repositories/settings_repository.dart';

/// App-wide locale: loads from [SettingsRepository], exposes [localeNotifier],
/// and [setLocale] to persist and notify. Initialize with [init] before [runApp].
@lazySingleton
class AppLocaleService {
  AppLocaleService(this._repository);

  final SettingsRepository _repository;

  final ValueNotifier<Locale> _localeNotifier = ValueNotifier(const Locale('en'));

  ValueNotifier<Locale> get localeNotifier => _localeNotifier;

  /// Loads saved locale and sets [localeNotifier]. Call once at startup.
  Future<void> init() async {
    final code = await _repository.getLocaleLanguageCode();
    _localeNotifier.value = code != null ? Locale(code) : const Locale('en');
  }

  /// Persists [locale] and updates [localeNotifier] so the app rebuilds.
  Future<void> setLocale(Locale locale) async {
    await _repository.setLocaleLanguageCode(locale.languageCode);
    _localeNotifier.value = locale;
  }
}
