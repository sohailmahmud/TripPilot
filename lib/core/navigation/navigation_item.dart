import 'package:flutter/material.dart';

/// Enumeration of all navigation routes in the app
enum NavigationItem {
  home(
    label: 'Home',
    icon: Icons.home_rounded,
    route: '/',
    navIndex: 0,
  ),
  search(
    label: 'Search',
    icon: Icons.flight_rounded,
    route: '/search',
    navIndex: 1,
  ),
  ideas(
    label: 'Ideas',
    icon: Icons.auto_awesome_rounded,
    route: '/recommendations',
    navIndex: 2,
  ),
  budget(
    label: 'Budget',
    icon: Icons.credit_card_rounded,
    route: '/budget',
    navIndex: 3,
  ),
  account(
    label: 'Account',
    icon: Icons.person_rounded,
    route: '/account',
    navIndex: 4,
  );

  final String label;
  final IconData icon;
  final String route;
  final int navIndex;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.navIndex,
  });

  /// Get NavigationItem from route path
  static NavigationItem fromRoute(String route) {
    for (final item in NavigationItem.values) {
      if (item.route == route) {
        return item;
      }
    }
    return NavigationItem.home;
  }

  /// Get NavigationItem from index
  static NavigationItem fromIndex(int index) {
    for (final item in NavigationItem.values) {
      if (item.navIndex == index) {
        return item;
      }
    }
    return NavigationItem.home;
  }

  /// Get index from route
  static int getIndexFromRoute(String route) {
    return fromRoute(route).navIndex;
  }

  /// Get all navigation items (excluding FAB)
  static List<NavigationItem> getVisibleItems() {
    return [
      NavigationItem.home,
      NavigationItem.search,
      // Ideas is FAB, skip
      NavigationItem.budget,
      NavigationItem.account,
    ];
  }
}
