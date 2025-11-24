import 'package:go_router/go_router.dart';

/// Extension methods for easy navigation using go_router.
extension AppNavigation on GoRouterState {
  /// Check if the current route matches a path.
  bool isRoute(String path) => matchedLocation == path;
}
