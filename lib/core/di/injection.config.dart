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
import '../../data/location/location_service_impl.dart' as _i420;
import '../../data/places/repositories/place_repository_impl.dart' as _i587;
import '../../data/presence/repositories/presence_repository_impl.dart'
    as _i738;
import '../../data/settings/repositories/settings_repository_impl.dart'
    as _i527;
import '../../domain/location/location_service.dart' as _i192;
import '../../domain/places/repositories/place_repository.dart' as _i267;
import '../../domain/places/use_cases/add_place.dart' as _i661;
import '../../domain/places/use_cases/get_places.dart' as _i868;
import '../../domain/places/use_cases/remove_place.dart' as _i1018;
import '../../domain/places/use_cases/update_place.dart' as _i604;
import '../../domain/presence/repositories/presence_repository.dart' as _i313;
import '../../domain/presence/use_cases/get_aggregated_presence.dart' as _i653;
import '../../domain/presence/use_cases/get_presence_for_month.dart' as _i833;
import '../../domain/presence/use_cases/get_presences_for_day.dart' as _i766;
import '../../domain/presence/use_cases/set_presence.dart' as _i827;
import '../../domain/settings/repositories/settings_repository.dart' as _i647;
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
    gh.lazySingleton<_i192.LocationService>(() => _i420.LocationServiceImpl());
    gh.lazySingleton<_i647.SettingsRepository>(
      () => _i527.SettingsRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i267.PlaceRepository>(
      () => _i587.PlaceRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i313.PresenceRepository>(
      () => _i738.PresenceRepositoryImpl(gh<_i160.AppDatabase>()),
    );
    gh.factory<_i653.GetAggregatedPresence>(
      () => _i653.GetAggregatedPresence(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i833.GetPresenceForMonth>(
      () => _i833.GetPresenceForMonth(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i766.GetPresencesForDay>(
      () => _i766.GetPresencesForDay(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i827.SetPresence>(
      () => _i827.SetPresence(gh<_i313.PresenceRepository>()),
    );
    gh.factory<_i661.AddPlace>(
      () => _i661.AddPlace(gh<_i267.PlaceRepository>()),
    );
    gh.factory<_i868.GetPlaces>(
      () => _i868.GetPlaces(gh<_i267.PlaceRepository>()),
    );
    gh.factory<_i1018.RemovePlace>(
      () => _i1018.RemovePlace(gh<_i267.PlaceRepository>()),
    );
    gh.factory<_i604.UpdatePlace>(
      () => _i604.UpdatePlace(gh<_i267.PlaceRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
