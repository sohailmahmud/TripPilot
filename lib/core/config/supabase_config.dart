import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_pilot/core/constants/app_constants.dart';

/// Supabase Configuration
class SupabaseConfig {
  // Get credentials from .env file
  static String get supabaseUrl => AppConstants.supabaseUrl;
  static String get supabaseAnonKey => AppConstants.supabaseAnonKey;

  // Table names
  static const String tripsTable = 'trips';
  static const String flightsTable = 'flights';
  static const String hotelsTable = 'hotels';
  static const String activitiesTable = 'activities';
  static const String budgetsTable = 'budgets';
  static const String userPreferencesTable = 'user_preferences';
  static const String itineraryTable = 'itinerary_items';

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get authenticated user session
  static Session? get session => Supabase.instance.client.auth.currentSession;

  /// Get current user
  static User? get currentUser => Supabase.instance.client.auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
}
