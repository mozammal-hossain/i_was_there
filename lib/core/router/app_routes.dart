/// Central definition of app route paths. Use these instead of hardcoded strings.
abstract final class AppRoutes {
  AppRoutes._();

  static const String root = '/';
  static const String forceUpdate = '/force-update';
  static const String onboarding = '/onboarding';
  static const String placeAdd = '/places/add';
  static const String placeEditPath = '/places/edit/:id';

  /// Builds the edit-place path for [placeId].
  static String placeEdit(String placeId) => '/places/edit/$placeId';
}
