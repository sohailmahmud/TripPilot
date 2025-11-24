import 'package:dio/dio.dart';
import 'package:trip_pilot/core/utils/logger_util.dart';

/// Service for handling Amadeus API authentication and flight searches
/// 
/// ⚠️ SANDBOX ENVIRONMENT:
/// This service uses the Amadeus test/sandbox API (test.api.amadeus.com)
/// 
/// IMPORTANT: Do NOT use personal information in sandbox testing
/// - Use only test flight data
/// - Use dummy passenger information (test names, emails)
/// - No real transactions or bookings
/// - Sandbox data is not persistent
/// 
/// To switch to production:
/// 1. Update baseUrl to: https://api.amadeus.com/v2
/// 2. Use production API credentials
/// 3. Implement production security measures
class AmadeusFlightService {
  late final Dio _dio;
  String? _accessToken;
  DateTime? _tokenExpiration;

  static const String baseUrl = "https://test.api.amadeus.com/v2";
  static const String authUrl = "https://test.api.amadeus.com/v1/security/oauth2/token";

  final String clientId;
  final String clientSecret;

  AmadeusFlightService({
    required this.clientId,
    required this.clientSecret,
  }) {
    // Configure Dio to not throw on error status codes
    _dio = Dio(
      BaseOptions(
        validateStatus: (status) => true, // Don't throw on any status code
      ),
    );
  }

  /// Get or refresh OAuth2 access token
  Future<String?> getAccessToken() async {
    try {
      // Return cached token if still valid
      if (_accessToken != null &&
          _tokenExpiration != null &&
          DateTime.now().isBefore(_tokenExpiration!)) {
        return _accessToken;
      }

      AppLogger.info('Requesting new Amadeus OAuth2 token');

      final response = await _dio.post(
        authUrl,
        data: 'grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'];
        final expiresIn = response.data['expires_in'] as int? ?? 3600;
        _tokenExpiration = DateTime.now().add(Duration(seconds: expiresIn - 60));
        
        AppLogger.info('Amadeus token obtained, expires in $expiresIn seconds');
        return _accessToken;
      } else {
        AppLogger.error('Token request failed with status ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      AppLogger.error('Failed to obtain Amadeus token: $e', error: e);
    }
    return null;
  }

  /// Search for flights using Amadeus Flight Offers Search API
  Future<Map<String, dynamic>?> searchFlightOffers({
    required String originCode, // IATA code (e.g., 'NYC')
    required String destinationCode, // IATA code (e.g., 'LON')
    required DateTime departureDate,
    DateTime? returnDate,
    int adults = 1,
    int children = 0,
    int infants = 0,
    int maxResults = 20,
  }) async {
    try {
      // Validate dates first
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final depDate = DateTime(departureDate.year, departureDate.month, departureDate.day);
      
      if (depDate.isBefore(today)) {
        AppLogger.error('Departure date cannot be in the past: $departureDate');
        return null;
      }
      if (returnDate != null && returnDate.isBefore(departureDate)) {
        AppLogger.error('Return date must be after departure date');
        return null;
      }

      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('No access token available - check Amadeus credentials');
        return null;
      }

      final departatureDateStr = _formatDate(departureDate);
      final params = {
        'originLocationCode': originCode,
        'destinationLocationCode': destinationCode,
        'departureDate': departatureDateStr,
        if (returnDate != null) 'returnDate': _formatDate(returnDate),
        'adults': adults.toString(),
        if (children > 0) 'children': children.toString(),
        if (infants > 0) 'infants': infants.toString(),
        'max': maxResults.toString(),
        'currencyCode': 'USD',
      };

      AppLogger.info('Searching flights: $originCode → $destinationCode on $departatureDateStr');

      final response = await _dio.get(
        '$baseUrl/shopping/flight-offers',
        queryParameters: params,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final flightCount = response.data['data']?.length ?? 0;
        AppLogger.info('Flight search successful: $flightCount results found');
        return response.data;
      } else {
        AppLogger.error('Flight search returned status ${response.statusCode}: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        AppLogger.error(
          'Amadeus API error (${e.response?.statusCode}): ${e.response?.data}',
          error: e,
        );
      } else {
        AppLogger.error('Network error during flight search: ${e.message}', error: e);
      }
    } catch (e) {
      AppLogger.error('Unexpected error in flight search: $e', error: e);
    }
    return null;
  }

  /// Get airport autocomplete suggestions
  Future<List<Map<String, dynamic>>> getAirportSearch(String keyword) async {
    try {
      final token = await getAccessToken();
      if (token == null) return [];

      final response = await _dio.get(
        '$baseUrl/reference-data/locations',
        queryParameters: {
          'keyword': keyword,
          'subType': 'AIRPORT',
          'view': 'FULL',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final airports = (response.data['data'] as List?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [];
        AppLogger.info('Found ${airports.length} airports for "$keyword"');
        return airports;
      }
    } catch (e) {
      AppLogger.error('Airport search failed', error: e);
    }
    return [];
  }

  /// Search for hotels by city code using Amadeus Hotel Search API
  Future<Map<String, dynamic>?> searchHotels({
    required String cityCode, // City code (e.g., 'NYC' for New York)
    required DateTime checkInDate,
    required DateTime checkOutDate,
    int adults = 1,
    int children = 0,
    int radius = 5, // Search radius in km
    int pageSize = 20,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('No access token available for hotel search');
        return null;
      }

      final checkInStr = _formatDate(checkInDate);
      final checkOutStr = _formatDate(checkOutDate);
      final params = {
        'cityCode': cityCode,
        'checkInDate': checkInStr,
        'checkOutDate': checkOutStr,
        'adults': adults.toString(),
        if (children > 0) 'children': children.toString(),
        'radius': radius.toString(),
        'radiusUnit': 'KM',
        'pageSize': pageSize.toString(),
      };

      AppLogger.info('Searching hotels in $cityCode from $checkInStr to $checkOutStr');

      final response = await _dio.get(
        '$baseUrl/shopping/hotel-offers',
        queryParameters: params,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final hotelCount = response.data['data']?.length ?? 0;
        AppLogger.info('Hotel search successful: $hotelCount results found');
        return response.data;
      } else {
        AppLogger.error('Hotel search returned status ${response.statusCode}: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        AppLogger.error(
          'Hotel API error (${e.response?.statusCode}): ${e.response?.data}',
          error: e,
        );
      } else {
        AppLogger.error('Network error during hotel search: ${e.message}', error: e);
      }
    } catch (e) {
      AppLogger.error('Unexpected error in hotel search: $e', error: e);
    }
    return null;
  }

  /// Search for tours and activities using Amadeus Tours and Activities API
  Future<Map<String, dynamic>?> searchActivities({
    required double latitude,
    required double longitude,
    int radius = 15, // Search radius in km
    int pageSize = 20,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('No access token available for activities search');
        return null;
      }

      final params = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toString(),
        'pageSize': pageSize.toString(),
      };

      AppLogger.info('Searching activities at coordinates: $latitude, $longitude');

      final response = await _dio.get(
        '$baseUrl/shopping/activities',
        queryParameters: params,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final activityCount = response.data['data']?.length ?? 0;
        AppLogger.info('Activities search successful: $activityCount results found');
        return response.data;
      } else {
        AppLogger.warning('Activities search returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        AppLogger.error(
          'Activities API error (${e.response?.statusCode}): ${e.response?.data}',
          error: e,
        );
      } else {
        AppLogger.error('Network error during activities search: ${e.message}', error: e);
      }
    } catch (e) {
      AppLogger.error('Unexpected error in activities search: $e', error: e);
    }
    return null;
  }

  /// Get city information by keyword
  Future<List<Map<String, dynamic>>> getCitySearch(String keyword) async {
    try {
      final token = await getAccessToken();
      if (token == null) return [];

      final response = await _dio.get(
        '$baseUrl/reference-data/locations',
        queryParameters: {
          'keyword': keyword,
          'subType': 'CITY',
          'view': 'FULL',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final cities = (response.data['data'] as List?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [];
        AppLogger.info('Found ${cities.length} cities for "$keyword"');
        return cities;
      }
    } catch (e) {
      AppLogger.error('City search failed', error: e);
    }
    return [];
  }

  /// Format DateTime to ISO date string (yyyy-MM-dd)
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }
}
