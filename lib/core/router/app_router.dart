import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_pilot/presentation/screens/account_screen.dart';
import 'package:trip_pilot/presentation/screens/home_screen.dart';
import 'package:trip_pilot/presentation/screens/search_screen.dart';
import 'package:trip_pilot/presentation/screens/budget_tracker_screen.dart';
import 'package:trip_pilot/presentation/screens/recommendations_screen.dart';

/// Application router configuration using go_router.
/// Provides named routes and deep linking support.
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: HomeScreen(),
      ),
      routes: [
        GoRoute(
          path: 'search',
          name: 'search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path: 'budget',
          name: 'budget',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BudgetTrackerScreen(),
          ),
        ),
        GoRoute(
          path: 'recommendations',
          name: 'recommendations',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: RecommendationsScreen(),
          ),
        ),
        GoRoute(
          path: 'trip-details',
          name: 'trip-details',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: 'account',
          name: 'account',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AccountScreen(),
          ),
        ),
      ],
    ),
  ],
  
  /// Error handler for unknown routes
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page not found!'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
