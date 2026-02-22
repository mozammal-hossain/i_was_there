import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global [GetIt] instance. Use [configureDependencies] from main to initialize.
final getIt = GetIt.instance;

/// Configures all dependencies registered via injectable annotations.
/// Call this once during app startup (e.g. in [main]).
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
