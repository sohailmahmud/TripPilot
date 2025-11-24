import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trip_pilot/core/utils/logger_util.dart';

/// API Client Configuration for Trip Pilot
/// 
/// IMPORTANT: This configuration uses sandbox/test APIs by default.
/// 
/// ⚠️ SECURITY NOTE:
/// - Never use personal information when testing with sandbox APIs
/// - Use only test/dummy data for development and testing
/// - Amadeus API: Uses test.api.amadeus.com (sandbox environment)
/// - Test data only - no real transactions
/// 
/// For production use:
/// - Switch to production API endpoints
/// - Use real API credentials
/// - Implement proper data protection measures
class ApiClientConfig {
  static final Dio _dio = Dio();

  // API Keys from .env file
  static String get amadeusClientId => dotenv.env['AMADEUS_CLIENT_ID'] ?? '';
  static String get amadeusClientSecret => dotenv.env['AMADEUS_CLIENT_SECRET'] ?? '';
  static String get rapidApiKey => dotenv.env['RAPID_API_KEY'] ?? '';
  static String get getYourGuideKey => dotenv.env['GET_YOUR_GUIDE_API_KEY'] ?? '';
  static String get googlePlacesKey =>
      dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

  // Base URLs
  static const String amadeusBaseUrl = 'test.api.amadeus.com'; // Using test/sandbox
  static const String rapidApiBaseUrl = 'https://api.api-ninjas.com';
  static const String getYourGuideBaseUrl = 'https://api.getyourguide.com';
  static const String googlePlacesUrl =
      'https://maps.googleapis.com/maps/api';

  /// Initialize Dio with base configuration
  static Dio get dio {
    _configureDio();
    return _dio;
  }

  static void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    );

    // Add logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info('API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('API Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.error('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Create Amadeus API client with authentication
  static Dio getAmadeusClient() {
    final client = Dio(_dio.options);
    client.options.baseUrl = amadeusBaseUrl;
    
    // Add Amadeus auth interceptor
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Amadeus uses Bearer token authentication
          // Token should be obtained before making requests
          return handler.next(options);
        },
      ),
    );

    return client;
  }

  /// Create Rapid API client with headers
  static Dio getRapidApiClient() {
    final client = Dio(_dio.options);
    client.options.baseUrl = rapidApiBaseUrl;
    
    // Add Rapid API headers
    client.options.headers.addAll({
      'X-Api-Key': rapidApiKey,
      'Content-Type': 'application/json',
    });

    return client;
  }

  /// Create GetYourGuide API client
  static Dio getGetYourGuideClient() {
    final client = Dio(_dio.options);
    client.options.baseUrl = getYourGuideBaseUrl;
    
    client.options.headers.addAll({
      'Authorization': 'Bearer $getYourGuideKey',
      'Content-Type': 'application/json',
    });

    return client;
  }

  /// Create Google Places API client
  static Dio getGooglePlacesClient() {
    final client = Dio(_dio.options);
    client.options.baseUrl = googlePlacesUrl;
    
    return client;
  }
}
