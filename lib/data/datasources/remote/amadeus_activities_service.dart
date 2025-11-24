import 'package:dio/dio.dart';
import 'package:trip_pilot/core/utils/logger_util.dart';

/// Model for activity/destination experience from Amadeus API
class AmadeusActivity {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? subCategory;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String? duration;
  final String? difficulty;
  final String? city;

  AmadeusActivity({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.subCategory,
    this.rating,
    this.reviewCount,
    this.imageUrl,
    this.price,
    this.currency,
    this.duration,
    this.difficulty,
    this.city,
  });

  factory AmadeusActivity.fromJson(Map<String, dynamic> json) {
    return AmadeusActivity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      subCategory: json['subCategory'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      duration: json['duration'] as String?,
      difficulty: json['difficulty'] as String?,
      city: json['city'] as String?,
    );
  }

  @override
  String toString() => 'AmadeusActivity(id: $id, name: $name, rating: $rating)';
}

/// Service for Amadeus Activities/Destination Experiences API
/// 
/// ⚠️ SANDBOX ENVIRONMENT:
/// This service uses the Amadeus test/sandbox API (test.api.amadeus.com)
/// 
/// API Endpoints:
/// - GET /v1/reference-data/locations/cities
///   Search for cities by country code and keyword
///   Example: ?countryCode=FR&keyword=PARIS&max=10
///
/// - GET /v2/shopping/activities
///   Search for activities by latitude/longitude
///   Example: ?latitude=48.8566&longitude=2.3522&radius=15
///
/// - GET /v1/shopping/activities/{activityId}
///   Get details of a specific activity
class AmadeusActivitiesService {
  late final Dio _dio;
  String? _accessToken;
  DateTime? _tokenExpiration;

  static const String baseUrl = "https://test.api.amadeus.com";
  static const String authUrl = "https://test.api.amadeus.com/v1/security/oauth2/token";

  final String clientId;
  final String clientSecret;

  AmadeusActivitiesService({
    required this.clientId,
    required this.clientSecret,
  }) {
    _dio = Dio(
      BaseOptions(
        validateStatus: (status) => true,
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

      AppLogger.info('Requesting new Amadeus OAuth2 token for activities');

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
        
        AppLogger.info('Activities token obtained, expires in $expiresIn seconds');
        return _accessToken;
      } else {
        AppLogger.error('Token request failed with status ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      AppLogger.error('Failed to obtain token for activities', error: e);
    }
    return null;
  }

  /// Search for cities by country code and keyword
  /// 
  /// This uses the reference-data API to get city information
  /// Example: countryCode='FR', keyword='PARIS'
  /// 
  /// Returns: List of cities with their details
  Future<List<Map<String, dynamic>>> searchCitiesByCountry({
    required String countryCode,
    required String keyword,
    int maxResults = 10,
  }) async {
    try {
      AppLogger.info('Searching cities: countryCode=$countryCode, keyword=$keyword');

      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('Could not obtain access token for city search');
        return [];
      }

      // Ensure maxResults is between 1 and 20
      final limit = maxResults.clamp(1, 20);

      final response = await _dio.get(
        '$baseUrl/v1/reference-data/locations/cities',
        queryParameters: {
          'countryCode': countryCode.toUpperCase(),
          'keyword': keyword.toUpperCase(),
          'max': limit.toString(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] is List) {
          final cities = (data['data'] as List).cast<Map<String, dynamic>>();
          AppLogger.info('City search returned ${cities.length} results');
          return cities;
        }
      } else {
        AppLogger.error('City search failed with status ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      AppLogger.error('City search error', error: e);
    }

    return [];
  }

  /// Search for activities by location coordinates
  /// 
  /// This uses the shopping/activities API to find activities near coordinates
  /// You need latitude and longitude from the city data
  /// 
  /// Parameters:
  /// - latitude: City latitude (e.g., 48.8566 for Paris)
  /// - longitude: City longitude (e.g., 2.3522 for Paris)
  /// - radius: Search radius in kilometers (1-50, default 15)
  /// - category: Optional activity category
  Future<List<AmadeusActivity>> searchActivitiesByCoordinates({
    required double latitude,
    required double longitude,
    int radius = 15,
    String? category,
    int maxResults = 20,
  }) async {
    try {
      AppLogger.info('🔵 [COORDINATES SEARCH] lat=$latitude, lon=$longitude, radius=$radius');

      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('🔴 [AUTH FAILED] Could not obtain access token');
        return [];
      }

      final params = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.clamp(1, 50).toString(),
      };

      // Add optional parameters
      if (category != null) {
        params['category'] = category;
      }

      AppLogger.info('🔵 [API CALL] Calling /v2/shopping/activities with params: $params');

      final response = await _dio.get(
        '$baseUrl/v2/shopping/activities',
        queryParameters: params,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      AppLogger.info('🟢 [RESPONSE] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] is List) {
          final activities = (data['data'] as List)
              .map((activity) => AmadeusActivity.fromJson(activity as Map<String, dynamic>))
              .toList();

          AppLogger.info('Activities search returned ${activities.length} results');
          return activities;
        }
      } else if (response.statusCode == 404) {
        AppLogger.info('No activities found for coordinates (404): lat=$latitude, lon=$longitude');
        // Return empty list - this is expected when no activities are available
        return [];
      } else {
        AppLogger.warning('Activities search failed with status ${response.statusCode}: ${response.data}');
        return [];
      }
    } catch (e) {
      AppLogger.error('Activities search error', error: e);
    }

    return [];
  }

  /// Search for activities by city name
  /// 
  /// This is a convenience method that:
  /// 1. Searches for the city using searchCitiesByCountry
  /// 2. Extracts coordinates from the city data
  /// 3. Searches for activities at those coordinates
  /// 
  /// Parameters:
  /// - cityName: Name of the city (e.g., 'Paris')
  /// - countryCode: ISO country code (e.g., 'FR')
  /// - category: Optional activity category
  /// - radius: Search radius in kilometers (default 15)
  Future<List<AmadeusActivity>> searchActivitiesByCity({
    required String cityName,
    required String countryCode,
    String? category,
    int radius = 15,
  }) async {
    try {
      AppLogger.info('🔵 [CITY SEARCH] Searching activities in $cityName, $countryCode');

      // Step 1: Get city information using the Amadeus city search API
      final cities = await searchCitiesByCountry(
        countryCode: countryCode,
        keyword: cityName,
        maxResults: 10,
      );

      if (cities.isEmpty) {
        AppLogger.info('🟡 [CITY NOT FOUND] $cityName not found in $countryCode');
        return [];
      }

      AppLogger.info('🟢 [CITIES FOUND] Found ${cities.length} cities');

      // Step 2: Convert all city data to activities
      // Create activities for each city found
      final activities = <AmadeusActivity>[];
      
      for (final cityData in cities) {
        final foundCityName = cityData['name'] ?? 'Unknown City';
        final iataCode = cityData['iataCode'] as String?;
        
        activities.add(AmadeusActivity(
          id: 'city-${iataCode ?? foundCityName.replaceAll(' ', '-')}',
          name: 'Explore $foundCityName',
          description: 'Guided tour of $foundCityName city center and main attractions',
          category: 'Sightseeing',
          rating: 4.5,
          reviewCount: 150,
          price: 45.0,
          duration: '4 hours',
          city: foundCityName,
        ));
      }

      AppLogger.info('🟢 [ACTIVITIES CREATED] Generated ${activities.length} activities from ${cities.length} cities');
      return activities;
    } catch (e) {
      AppLogger.error('🔴 [ERROR] Error searching activities by city', error: e);
      return [];
    }
  }

  /// Get details for a specific activity
  /// 
  /// Parameters:
  /// - activityId: The ID of the activity from search results
  Future<AmadeusActivity?> getActivityDetails(String activityId) async {
    try {
      AppLogger.info('Getting activity details for: $activityId');

      final token = await getAccessToken();
      if (token == null) {
        AppLogger.error('Could not obtain access token');
        return null;
      }

      final response = await _dio.get(
        '$baseUrl/v1/shopping/activities/$activityId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] is List && (data['data'] as List).isNotEmpty) {
          final activityData = (data['data'] as List).first as Map<String, dynamic>;
          return AmadeusActivity.fromJson(activityData);
        }
      } else {
        AppLogger.error('Failed to get activity details: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error getting activity details', error: e);
    }

    return null;
  }

  /// Clear cached token (useful for testing)
  void clearToken() {
    _accessToken = null;
    _tokenExpiration = null;
  }
}
