import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  static const List<String> _routes = [
    '/',           // 0: Home
    '/search',     // 1: Search
    '/recommendations',  // 2: Ideas (FAB)
    '/budget',     // 3: Budget
    '/account',    // 4: Account
  ];

  NavigationBloc() : super(const NavigationInitial()) {
    on<NavigationIndexChanged>(_onNavigationIndexChanged);
    on<NavigationRouteChanged>(_onNavigationRouteChanged);
  }

  Future<void> _onNavigationIndexChanged(
    NavigationIndexChanged event,
    Emitter<NavigationState> emit,
  ) async {
    if (event.index >= 0 && event.index < _routes.length) {
      final route = _routes[event.index];
      emit(
        NavigationChanged(
          selectedIndex: event.index,
          selectedRoute: route,
        ),
      );
    }
  }

  Future<void> _onNavigationRouteChanged(
    NavigationRouteChanged event,
    Emitter<NavigationState> emit,
  ) async {
    final index = _routes.indexOf(event.route);
    if (index != -1) {
      emit(
        NavigationChanged(
          selectedIndex: index,
          selectedRoute: event.route,
        ),
      );
    }
  }

  /// Get the current selected index
  int get currentIndex => state.selectedIndex;

  /// Get the current selected route
  String get currentRoute => _routes[state.selectedIndex];

  /// Convert route to index
  static int getIndexFromRoute(String route) {
    return _routes.indexOf(route);
  }
}
