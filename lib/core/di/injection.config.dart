// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/database/app_database.dart' as _i160;
import '../../data/location/geocoding_service_impl.dart' as _i362;
import '../../data/location/location_service_impl.dart' as _i420;
import '../../data/places/repositories/place_repository_impl.dart' as _i587;
import '../../data/presence/repositories/presence_repository_impl.dart'
    as _i738;
import '../../data/settings/repositories/settings_repository_impl.dart'
    as _i527;
import '../../domain/location/geocoding_service.dart' as _i139;
import '../../domain/location/location_service.dart' as _i192;
import '../../domain/location/use_cases/get_current_location_with_address_use_case.dart'
    as _i687;
import '../../domain/location/use_cases/get_location_from_address_use_case.dart'
    as _i1035;
import '../../domain/location/use_cases/get_location_from_coordinates_use_case.dart'
    as _i648;
import '../../domain/places/repositories/place_repository.dart' as _i267;
import '../../domain/places/use_cases/add_place_use_case.dart' as _i662;
import '../../domain/places/use_cases/get_places_use_case.dart' as _i439;
import '../../domain/places/use_cases/remove_place_use_case.dart' as _i550;
import '../../domain/places/use_cases/update_place_use_case.dart' as _i283;
import '../../domain/presence/repositories/presence_repository.dart' as _i313;
import '../../domain/presence/use_cases/get_aggregated_presence_use_case.dart'
    as _i379;
import '../../domain/presence/use_cases/get_presence_for_month_use_case.dart'
    as _i629;
import '../../domain/presence/use_cases/get_presences_for_day_use_case.dart'
    as _i374;
import '../../domain/presence/use_cases/set_presence_use_case.dart' as _i792;
import '../../domain/settings/repositories/settings_repository.dart' as _i647;
import '../../domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart'
    as _i41;
import '../../domain/settings/use_cases/get_last_sync_time_use_case.dart'
    as _i411;
import '../../domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart'
    as _i410;
import '../force_update/force_update_service.dart' as _i378;
import '../locale/app_locale_service.dart' as _i700;
import '../url_launcher/url_launcher_service.dart' as _i491;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i160.AppDatabase>(() => appModule.appDatabase);
    gh.lazySingleton<_i378.ForceUpdateService>(
      () => _i378.ForceUpdateService(),
    );
    gh.lazySingleton<_i491.UrlLauncherService>(
      () => _i491.UrlLauncherService(),
    );
    gh.lazySingleton<_i139.GeocodingService>(
      () => _i362.GeocodingServiceImpl(),
    );
    gh.lazySingleton<_i192.LocationService>(() => _i420.LocationServiceImpl());
    gh.factory<_i1035.GetLocationFromAddressUseCase>(
      () => _i1035.GetLocationFromAddressUseCase(gh<_i139.GeocodingService>()),
    );
    gh.factory<_i648.GetLocationFromCoordinatesUseCase>(
      () =>
          _i648.GetLocationFromCoordinatesUseCase(gh<_i139.GeocodingService>()),
    );
    gh.lazySingleton<_i647.SettingsRepository>(
      () => _i527.SettingsRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i267.PlaceRepository>(
      () => _i587.PlaceRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i313.PresenceRepository>(
      () => _i738.PresenceRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.factory<_i379.GetAggregatedPresenceUseCase>(
      () => _i379.GetAggregatedPresenceUseCase(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i629.GetPresenceForMonthUseCase>(
      () => _i629.GetPresenceForMonthUseCase(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i374.GetPresencesForDayUseCase>(
      () => _i374.GetPresencesForDayUseCase(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i792.SetPresenceUseCase>(
      () => _i792.SetPresenceUseCase(gh<_i313.PresenceRepository>()),
    );
    gh.lazySingleton<_i700.AppLocaleService>(
      () => _i700.AppLocaleService(gh<_i647.SettingsRepository>()),
    );
    gh.factory<_i41.GetCalendarSyncEnabledUseCase>(
      () => _i41.GetCalendarSyncEnabledUseCase(gh<_i647.SettingsRepository>()),
    );
    gh.factory<_i410.SetCalendarSyncEnabledUseCase>(
      () => _i410.SetCalendarSyncEnabledUseCase(gh<_i647.SettingsRepository>()),
    );
    gh.factory<_i411.GetLastSyncTimeUseCase>(
      () => _i411.GetLastSyncTimeUseCase(gh<_i647.SettingsRepository>()),
    );
    gh.factory<_i687.GetCurrentLocationWithAddressUseCase>(
      () => _i687.GetCurrentLocationWithAddressUseCase(
        gh<_i192.LocationService>(),
        gh<_i139.GeocodingService>(),
      ),
    );
    gh.factory<_i662.AddPlaceUseCase>(
      () => _i662.AddPlaceUseCase(gh<_i267.PlaceRepository>()),
    );
    gh.factory<_i439.GetPlacesUseCase>(
      () => _i439.GetPlacesUseCase(gh<_i267.PlaceRepository>()),
    );
    gh.factory<_i550.RemovePlaceUseCase>(
      () => _i550.RemovePlaceUseCase(gh<_i267.PlaceRepository>()),
    );
    gh.factory<_i283.UpdatePlaceUseCase>(
      () => _i283.UpdatePlaceUseCase(gh<_i267.PlaceRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
