import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-wide constants
class AppConstants {
  // API related
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Cache related
  static const Duration cacheDuration = Duration(hours: 1);
  static const String tripCacheKey = 'trip_cache';
  static const String flightCacheKey = 'flight_cache';
  static const String hotelCacheKey = 'hotel_cache';
  static const String activityCacheKey = 'activity_cache';

  // Supabase related
  static final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Trip defaults
  static const double defaultBudget = 5000.0;
  static const int defaultTripDays = 7;
  static const String defaultCurrency = 'USD';
}
