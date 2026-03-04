import 'package:injectable/injectable.dart';

import '../../data/database/app_database.dart';
import '../../data/sync/repositories/sync_repository_impl.dart';
import '../../domain/sync/repositories/sync_repository.dart';

/// Provides app-wide dependencies that are not annotated with @injectable
/// (e.g. database, platform types). Used by injectable code generation.
@module
abstract class AppModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  SyncRepository provideSyncRepository(AppDatabase db) =>
      SyncRepositoryImpl(db) as SyncRepository;
}
