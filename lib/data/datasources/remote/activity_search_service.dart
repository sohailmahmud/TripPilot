import 'package:trip_pilot/core/utils/logger_util.dart';
import 'package:trip_pilot/data/datasources/remote/amadeus_activities_service.dart';

/// Service for handling activity/tour searches using Amadeus API
/// Integrates with Amadeus Activities/Destination Experiences API
class ActivitySearchService {
  final AmadeusActivitiesService _amadeusService;
  final String? apiKey;

  ActivitySearchService({
    required AmadeusActivitiesService amadeusService,
    this.apiKey,
  }) : _amadeusService = amadeusService;

  /// Search for activities in a given location using Amadeus API
  /// 
  /// First tries to get activities from Amadeus API
  /// Falls back to generated mock activities if API fails
  Future<List<Map<String, dynamic>>> searchActivities({
    required String city,
    String? category,
  }) async {
    try {
      AppLogger.info('🔵 [ACTIVITY SEARCH] $city${category != null ? ' (category: $category)' : ''}');
      
      // Try to search using Amadeus (will attempt mapped country first)
      final activities = await _searchActivitiesFromAmadeus(city, category);
      
      if (activities.isNotEmpty) {
        AppLogger.info('🟢 [SUCCESS] Found ${activities.length} activities from Amadeus');
        return activities;
      }
      
      AppLogger.info('🟡 [FALLBACK] No activities from Amadeus, using mock');
      // Fallback to generated activities
      return _generateMockActivitiesForCity(city);
    } catch (e) {
      AppLogger.error('🔴 [ERROR] Activity search failed', error: e);
      // Fallback to generated activities
      return _generateMockActivitiesForCity(city);
    }
  }

  /// Map of well-known cities to their country codes
  static const Map<String, String> cityCountryMap = {
    'paris': 'FR',
    'london': 'GB',
    'berlin': 'DE',
    'madrid': 'ES',
    'rome': 'IT',
    'amsterdam': 'NL',
    'barcelona': 'ES',
    'vienna': 'AT',
    'prague': 'CZ',
    'athens': 'GR',
    'lisbon': 'PT',
    'zurich': 'CH',
    'geneva': 'CH',
    'brussels': 'BE',
    'dublin': 'IE',
    'oslo': 'NO',
    'stockholm': 'SE',
    'copenhagen': 'DK',
    'warsaw': 'PL',
    'new york': 'US',
    'los angeles': 'US',
    'chicago': 'US',
    'san francisco': 'US',
    'miami': 'US',
    'las vegas': 'US',
    'boston': 'US',
    'seattle': 'US',
    'denver': 'US',
    'houston': 'US',
    'toronto': 'CA',
    'vancouver': 'CA',
    'mexico city': 'MX',
    'buenos aires': 'AR',
    'rio de janeiro': 'BR',
    'sao paulo': 'BR',
    'santiago': 'CL',
    'bogota': 'CO',
    'lima': 'PE',
    'tokyo': 'JP',
    'osaka': 'JP',
    'kyoto': 'JP',
    'beijing': 'CN',
    'shanghai': 'CN',
    'hong kong': 'HK',
    'taipei': 'TW',
    'seoul': 'KR',
    'bangkok': 'TH',
    'phuket': 'TH',
    'singapore': 'SG',
    'kuala lumpur': 'MY',
    'jakarta': 'ID',
    'bali': 'ID',
    'manila': 'PH',
    'hanoi': 'VN',
    'ho chi minh': 'VN',
    'dubai': 'AE',
    'abu dhabi': 'AE',
    'riyadh': 'SA',
    'tel aviv': 'IL',
    'istanbul': 'TR',
    'cairo': 'EG',
    'cape town': 'ZA',
    'johannesburg': 'ZA',
    'lagos': 'NG',
    'sydney': 'AU',
    'melbourne': 'AU',
    'auckland': 'NZ',
    'delhi': 'IN',
    'mumbai': 'IN',
    'bangalore': 'IN',
    'kolkata': 'IN',
    'dhaka': 'BD',
  };

  /// Search for activities from Amadeus API
  /// Smart approach: Search city to get coordinates, then search activities by coordinates
  /// Falls back to mock data if API returns no results
  Future<List<Map<String, dynamic>>> _searchActivitiesFromAmadeus(
    String city,
    String? category,
  ) async {
    try {
      AppLogger.info('🔵 [AMADEUS SEARCH] Searching for activities in: $city');

      // Strategy: Use city-to-country map to narrow down, but only ONE country per city
      final cityLower = city.toLowerCase().trim();
      final mappedCountry = cityCountryMap[cityLower];

      if (mappedCountry != null) {
        AppLogger.info('🟢 [MAPPED] Found $city in country map: $mappedCountry');
        
        // Search activities using the mapped country - single attempt only
        try {
          final activities = await _amadeusService.searchActivitiesByCity(
            cityName: city,
            countryCode: mappedCountry,
            category: category,
            radius: 15,
          );

          if (activities.isNotEmpty) {
            AppLogger.info('✅ [SUCCESS] Found ${activities.length} activities from API');
            return _convertActivitiesToMap(activities, city, category);
          }
          
          AppLogger.info('⚠️ [NO API DATA] API returned no activities, using mock');
          return [];
        } catch (e) {
          AppLogger.info('⚠️ [API ERROR] Activity search failed, using mock: $e');
          return [];
        }
      }

      // If city is not in map, try only the TOP 5 most popular countries
      AppLogger.info('🟡 [UNMAPPED] City not in map, trying top 5 countries');
      
      final topCountries = ['US', 'FR', 'GB', 'JP', 'AE'];
      
      for (final countryCode in topCountries) {
        try {
          AppLogger.info('🔵 Trying $countryCode');
          final activities = await _amadeusService.searchActivitiesByCity(
            cityName: city,
            countryCode: countryCode,
            category: category,
            radius: 15,
          );

          if (activities.isNotEmpty) {
            AppLogger.info('✅ [SUCCESS] Found ${activities.length} in $countryCode');
            return _convertActivitiesToMap(activities, city, category);
          }
        } catch (e) {
          AppLogger.debug('⚠️ Not in $countryCode');
          continue;
        }
      }

      AppLogger.info('❌ [FAIL] No activities found in any country, using mock');
      return [];
    } catch (e) {
      AppLogger.error('❌ [CRASH] Amadeus activity search failed', error: e);
      return [];
    }
  }

  /// Convert AmadeusActivity objects to map format with required fields
  List<Map<String, dynamic>> _convertActivitiesToMap(
    List<AmadeusActivity> activities,
    String city,
    String? category,
  ) {
    return activities
        .map((activity) {
          // Extract duration in hours from string like "3 hours"
          int? durationHours;
          if (activity.duration != null) {
            try {
              durationHours = int.parse(activity.duration!.split(' ').first);
            } catch (e) {
              durationHours = 3; // Default to 3 hours
            }
          } else {
            durationHours = 3; // Default to 3 hours
          }

          return {
            'id': activity.id,
            'name': activity.name,
            'description': activity.description,
            'category': activity.category ?? category ?? 'Sightseeing',
            'price': activity.price ?? 50.0,
            'rating': activity.rating ?? 4.5,
            'reviewCount': activity.reviewCount ?? 100,
            'imageUrl': activity.imageUrl,
            'duration': durationHours,  // Now an int, not a string
            'city': city,
            // Required fields for ActivityModel
            'locationCity': city,
            'locationCountry': 'Unknown',
            'locationAddress': null,
            'currency': 'USD',
            'locationLat': 0.0,  // Default coordinates
            'locationLng': 0.0,  // Default coordinates
            'bookingUrl': null,
          };
        })
        .toList();
  }


  /// Generate mock activities for a city (fallback when API fails)
  List<Map<String, dynamic>> _generateMockActivitiesForCity(String city) {
    // Create empty city data object for the existing method
    final cityData = <String, dynamic>{};
    return _generateActivitiesFromCity(cityData, city);
  }

  /// Generate activities based on city data
  List<Map<String, dynamic>> _generateActivitiesFromCity(
    Map<String, dynamic> cityData,
    String city,
  ) {
    // Generate diverse activities based on city data

    return [
      {
        'id': '${city}_1',
        'name': 'City Walking Tour - Historic District',
        'description':
            'Explore the historic districts and landmarks of $city with a knowledgeable guide.',
        'category': 'Sightseeing',
        'city': city,
        'duration': '3 hours',
        'price': 45.0,
        'rating': 4.6,
        'reviewCount': 234,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Walking+Tour',
        'difficulty': 'Easy',
      },
      {
        'id': '${city}_2',
        'name': 'Local Food & Culture Experience',
        'description':
            'Enjoy authentic local cuisine and learn about $city\'s culinary traditions.',
        'category': 'Food & Dining',
        'city': city,
        'duration': '4 hours',
        'price': 65.0,
        'rating': 4.8,
        'reviewCount': 456,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Food+Tour',
        'difficulty': 'Easy',
      },
      {
        'id': '${city}_3',
        'name': 'Adventure Activity - Outdoor Exploration',
        'description':
            'Outdoor activities including hiking, biking, or water sports depending on location.',
        'category': 'Adventure',
        'city': city,
        'duration': '5 hours',
        'price': 75.0,
        'rating': 4.5,
        'reviewCount': 189,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Adventure',
        'difficulty': 'Moderate',
      },
      {
        'id': '${city}_4',
        'name': 'Museum & Art Gallery Tour',
        'description':
            'Guided tour through the finest museums and art galleries in $city.',
        'category': 'Cultural',
        'city': city,
        'duration': '3.5 hours',
        'price': 55.0,
        'rating': 4.4,
        'reviewCount': 312,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Museum',
        'difficulty': 'Easy',
      },
      {
        'id': '${city}_5',
        'name': 'Shopping & Local Markets',
        'description':
            'Discover local markets, boutiques, and shopping centers in $city.',
        'category': 'Shopping',
        'city': city,
        'duration': '4 hours',
        'price': 35.0,
        'rating': 4.3,
        'reviewCount': 267,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Shopping',
        'difficulty': 'Easy',
      },
      {
        'id': '${city}_6',
        'name': 'Evening Entertainment & Nightlife',
        'description':
            'Experience the best bars, clubs, and entertainment venues in $city.',
        'category': 'Nightlife',
        'city': city,
        'duration': '4 hours',
        'price': 50.0,
        'rating': 4.5,
        'reviewCount': 523,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Nightlife',
        'difficulty': 'Easy',
      },
      {
        'id': '${city}_7',
        'name': 'Sports & Recreation',
        'description':
            'Participate in local sports activities or watch live sporting events.',
        'category': 'Sports',
        'city': city,
        'duration': '3 hours',
        'price': 60.0,
        'rating': 4.2,
        'reviewCount': 145,
        'imageUrl': 'https://via.placeholder.com/400x300?text=Sports',
        'difficulty': 'Easy',
      },
    ];
  }

  /// Get activities by specific category
  Future<List<Map<String, dynamic>>> getActivitiesByCategory({
    required String city,
    required String category,
  }) async {
    final activities = await searchActivities(city: city, category: category);
    return activities;
  }

  /// Get top-rated activities
  Future<List<Map<String, dynamic>>> getTopRatedActivities({
    required String city,
  }) async {
    try {
      final activities = await searchActivities(city: city);
      
      // Sort by rating
      activities.sort((a, b) {
        final ratingA = (a['rating'] as num?)?.toDouble() ?? 0.0;
        final ratingB = (b['rating'] as num?)?.toDouble() ?? 0.0;
        return ratingB.compareTo(ratingA);
      });

      return activities.take(5).toList();
    } catch (e) {
      AppLogger.error('Failed to get top rated activities', error: e);
      return [];
    }
  }
}
