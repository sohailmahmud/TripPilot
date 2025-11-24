import 'package:dio/dio.dart';
import 'package:trip_pilot/core/utils/logger_util.dart';

/// Service for handling Amadeus API hotel searches
/// 
/// ⚠️ SANDBOX ENVIRONMENT:
/// This service uses the Amadeus test/sandbox API (test.api.amadeus.com)
/// 
/// IMPORTANT: Do NOT use personal information in sandbox testing
/// - Use only test hotel data
/// - Use dummy passenger information (test names, emails)
/// - No real transactions or bookings
/// - Sandbox data is not persistent
/// 
/// To switch to production:
/// 1. Update baseUrl to: https://api.amadeus.com/v2
/// 2. Use production API credentials
/// 3. Implement production security measures
class AmadeusHotelService {
  late final Dio _dio;
  String? _accessToken;
  DateTime? _tokenExpiration;

  static final String baseUrl = 'https://test.api.amadeus.com';
  static const String authUrl = "https://test.api.amadeus.com/v1/security/oauth2/token";

  final String clientId;
  final String clientSecret;

  AmadeusHotelService({
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

      AppLogger.info('Requesting new Amadeus OAuth2 token for hotel service');

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
        
        AppLogger.info('Amadeus hotel token obtained, expires in $expiresIn seconds');
        return _accessToken;
      } else {
        AppLogger.error('Hotel token request failed with status ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      AppLogger.error('Failed to obtain Amadeus hotel token: $e', error: e);
    }
    return null;
  }

  /// Search for hotels by city code using Amadeus Hotel List by City API
  /// API Reference: /v1/reference-data/locations/hotels/by-city
  /// Parameters: cityCode (required), radius (optional), radiusUnit (optional), amenities (optional), hotelSource (optional)
  Future<Map<String, dynamic>?> searchHotels({
    required String cityCode, // IATA city code (e.g., 'PAR', 'NCE')
    required DateTime checkInDate,
    required DateTime checkOutDate,
    int adults = 1,
    int children = 0,
    int infants = 0,
    int radius = 5, // Search radius
    String radiusUnit = 'KM', // 'KM' or 'MI'
    List<String>? amenities, // e.g., ['WI-FI_IN_ROOM', 'PARKING']
    String hotelSource = 'ALL', // 'ALL', 'AMADEUS', 'PROVIDER'
    int pageSize = 20,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('No access token available for hotel search');
        return null;
      }

      // Validate dates
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final checkInDate2 = DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
      
      if (checkInDate2.isBefore(today)) {
        AppLogger.error('Check-in date cannot be in the past: $checkInDate');
        return null;
      }
      if (checkOutDate.isBefore(checkInDate)) {
        AppLogger.error('Check-out date must be after check-in date');
        return null;
      }
      
      // Validate city code - must be 3-letter IATA code
      final normalizedCode = cityCode.trim().toUpperCase();
      if (normalizedCode.isEmpty) {
        AppLogger.error('City code is empty');
        return null;
      }
      if (normalizedCode.length != 3) {
        AppLogger.warning('City code "$normalizedCode" is not 3 letters - Amadeus hotel search requires IATA codes (e.g., "PAR", "NCE")');
        return null;
      }
      
      // Build query parameters for Hotel List by City endpoint
      // Required: cityCode
      // Optional: radius, radiusUnit, amenities, hotelSource
      final params = {
        'cityCode': normalizedCode,
        'radius': radius.toString(),
        'radiusUnit': radiusUnit,
        'hotelSource': hotelSource,
      };
      
      // Add amenities if provided
      if (amenities != null && amenities.isNotEmpty) {
        params['amenities'] = amenities.join(',');
      }

      AppLogger.info('Amadeus Hotel List by City API request');
      AppLogger.info('Endpoint: /v1/reference-data/locations/hotels/by-city');
      AppLogger.info('Parameters: cityCode=$normalizedCode, radius=$radius$radiusUnit, hotelSource=$hotelSource${amenities != null ? ', amenities=${amenities.join(",")}' : ''}');

      final response = await _dio.get(
        '$baseUrl/v1/reference-data/locations/hotels/by-city',
        queryParameters: params,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final hotelCount = response.data['data']?.length ?? 0;
        AppLogger.info('Hotel list retrieved successfully: $hotelCount hotels found');
        return response.data;
      } else if (response.statusCode == 404) {
        AppLogger.info('Hotel search returned 404 - no hotels available in this city');
        return null;
      } else {
        AppLogger.error('Hotel search returned status ${response.statusCode}: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        AppLogger.error(
          'Amadeus Hotel List API error (${e.response?.statusCode}): ${e.response?.data}',
          error: e,
        );
      } else {
        AppLogger.error('Network error during hotel search: ${e.message}', error: e);
      }
      return null;
    } catch (e) {
      AppLogger.error('Unexpected error in hotel search: $e', error: e);
      return null;
    }
  }

  /// Get hotel properties by destination ID
  Future<Map<String, dynamic>?> getHotelPropertyDetails({
    required String hotelId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('No access token available for hotel details');
        return null;
      }

      final checkInStr = _formatDate(checkInDate);
      final checkOutStr = _formatDate(checkOutDate);

      AppLogger.info('Fetching hotel details for: $hotelId');

      final response = await _dio.get(
        '$baseUrl/v2/shopping/hotel-offers',
        queryParameters: {
          'hotelIds': hotelId,
          'checkInDate': checkInStr,
          'checkOutDate': checkOutStr,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        AppLogger.info('Hotel details fetched successfully');
        return response.data;
      } else {
        AppLogger.error('Hotel details request failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      AppLogger.error('Error fetching hotel details: ${e.message}', error: e);
    } catch (e) {
      AppLogger.error('Unexpected error fetching hotel details: $e', error: e);
    }
    return null;
  }

  /// Search for locations/cities to get city codes
  Future<List<Map<String, dynamic>>> getCitySearch(String keyword) async {
    try {
      final token = await getAccessToken();
      if (token == null) return [];

      // First try with subType: CITY
      var response = await _dio.get(
        '$baseUrl/v1/reference-data/locations',
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
        if (cities.isNotEmpty) {
          AppLogger.info('Found ${cities.length} cities for "$keyword"');
          return cities;
        }
      }

      // If no results, try without subType (returns both airports and cities)
      AppLogger.info('No cities found with CITY subType, trying without subType filter');
      response = await _dio.get(
        '$baseUrl/v1/reference-data/locations',
        queryParameters: {
          'keyword': keyword,
          'view': 'FULL',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final locations = (response.data['data'] as List?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [];
        if (locations.isNotEmpty) {
          AppLogger.info('Found ${locations.length} locations for "$keyword" (mixed types)');
          return locations;
        }
      }

      AppLogger.info('Found 0 locations for "$keyword"');
    } catch (e) {
      AppLogger.error('City search failed for "$keyword": $e', error: e);
    }
    return [];
  }

  /// Format DateTime to ISO date string (yyyy-MM-dd)
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }
}

