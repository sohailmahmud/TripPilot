import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/domain/repositories/ai_recommendation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class AIRecommendationServiceImpl implements AIRecommendationService {
  final Dio dio;
  final Logger logger;
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-3.5-turbo';

  AIRecommendationServiceImpl({required this.dio, required this.logger}) {
    try {
      _setupDio();
      logger.i('✅ AIRecommendationServiceImpl initialized successfully');
    } catch (e) {
      logger.e('❌ Failed to initialize AIRecommendationServiceImpl: $e');
      rethrow;
    }
  }

  void _setupDio() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY not found in .env file');
    }

    logger.i('Initializing OpenAI API with key: ${apiKey.substring(0, 20)}...');
    
    dio.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getDestinationRecommendations({
    required String preferences,
    required int numberOfDays,
    required double budget,
  }) async {
    logger.i('🔍 getDestinationRecommendations called with preferences: $preferences');
    try {
      final prompt = '''Recommend 5 unique destinations for someone who likes $preferences,
has $numberOfDays days available, and a budget of \$$budget per person.

For each destination, provide:
1. Destination name
2. Why it matches their preferences
3. Best time to visit
4. Estimated total cost
5. Top 3-4 highlights

Format as a JSON array of objects with keys: name, reason, bestTime, estimatedCost, highlights(array)''';

      logger.i('Calling OpenAI API for destination recommendations...');
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a travel expert. Provide detailed destination recommendations in valid JSON format only, no markdown or extra text.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        },
      );
      logger.i('OpenAI API response received: ${response.statusCode}');

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'] as String;
        // Parse JSON response
        final jsonStr = _extractJsonFromResponse(content);
        final jsonData = _parseJsonArray(jsonStr);
        logger.i('Destination recommendations: ${jsonData.length} found');
        return Right(List<Map<String, dynamic>>.from(jsonData));
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio Error: $e');
      final statusCode = e.response?.statusCode;
      logger.e('OpenAI API Error Status: $statusCode, Message: ${e.message}');
      // If API fails (401, 429, 500+), return fallback recommendations
      if (statusCode == 401) {
        logger.w('OpenAI API authentication failed (401). Returning fallback recommendations.');
        return Right(_generateFallbackDestinations(preferences, numberOfDays, budget));
      } else if (statusCode == 429) {
        logger.w('OpenAI API rate limit exceeded (429). Returning fallback recommendations.');
        return Right(_generateFallbackDestinations(preferences, numberOfDays, budget));
      } else if (statusCode != null && statusCode >= 500) {
        logger.w('OpenAI API server error ($statusCode). Returning fallback recommendations.');
        return Right(_generateFallbackDestinations(preferences, numberOfDays, budget));
      }
      return Left(NetworkFailure(message: 'Failed to fetch recommendations: ${e.message}'));
    } catch (e) {
      logger.e('Error: $e');
      // Fallback for any other errors
      return Right(_generateFallbackDestinations(preferences, numberOfDays, budget));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> generateItinerary({
    required String destination,
    required int numberOfDays,
    required List<String> interests,
  }) async {
    try {
      final prompt = '''Create a detailed $numberOfDays-day itinerary for $destination 
for someone interested in ${interests.join(', ')}.

Format the response as valid JSON with the following structure:
{
  "destination": "$destination",
  "duration": $numberOfDays,
  "interests": ${interests},
  "itinerary": [
    {
      "day": 1,
      "theme": "...",
      "activities": ["...", "...", "..."],
      "meals": {
        "breakfast": "...",
        "lunch": "...",
        "dinner": "..."
      }
    }
  ],
  "estimatedBudget": ...
}

Include all $numberOfDays days with specific recommendations based on the interests provided.''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a travel itinerary expert. Provide detailed, practical itineraries in valid JSON format only.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'] as String;
        final jsonStr = _extractJsonFromResponse(content);
        final jsonData = _parseJson(jsonStr);
        logger.i('Itinerary generated for $destination');
        return Right(jsonData);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio Error: $e');
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 429 || (statusCode != null && statusCode >= 500)) {
        logger.w('OpenAI API unavailable ($statusCode). Returning fallback itinerary.');
        return Right(_generateFallbackItinerary(destination, numberOfDays, interests));
      }
      return Left(NetworkFailure(message: 'Itinerary generation failed: ${e.message}'));
    } catch (e) {
      logger.e('Error: $e');
      return Right(_generateFallbackItinerary(destination, numberOfDays, interests));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getLocalTips({
    required String destination,
  }) async {
    try {
      final prompt = '''Give 10 useful local tips and insider secrets for visiting $destination.
Include tips about:
- Best time to visit
- Transportation
- Money-saving tips
- Local customs
- Food recommendations
- Hidden gems

Format as a JSON array of strings: ["tip1", "tip2", ...]''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a local travel expert. Provide practical insider tips in valid JSON array format only.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'] as String;
        final jsonStr = _extractJsonFromResponse(content);
        final tips = _parseJsonArray(jsonStr);
        final tipsList = List<String>.from(tips);
        logger.i('Local tips fetched for $destination');
        return Right(tipsList);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio Error: $e');
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 429 || (statusCode != null && statusCode >= 500)) {
        logger.w('OpenAI API unavailable ($statusCode). Returning fallback tips.');
        return Right(_generateFallbackLocalTips(destination));
      }
      return Left(NetworkFailure(message: 'Local tips failed: ${e.message}'));
    } catch (e) {
      logger.e('Error: $e');
      return Right(_generateFallbackLocalTips(destination));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRestaurantRecommendations({
    required String destination,
    required String cuisineType,
  }) async {
    try {
      final prompt = '''Recommend 5 top-rated $cuisineType restaurants in $destination.

For each restaurant provide:
{
  "name": "...",
  "cuisine": "$cuisineType",
  "rating": 4.5-5.0,
  "reviews": number,
  "priceRange": "\$", "\$\$", "\$\$\$", or "\$\$\$\$",
  "specialty": "...",
  "address": "..."
}

Format as a JSON array of restaurant objects.''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a food critic and restaurant expert. Provide restaurant recommendations in valid JSON format only.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'] as String;
        final jsonStr = _extractJsonFromResponse(content);
        final restaurants = _parseJsonArray(jsonStr);
        logger.i('Restaurant recommendations fetched for $destination');
        return Right(List<Map<String, dynamic>>.from(restaurants));
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio Error: $e');
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 429 || (statusCode != null && statusCode >= 500)) {
        logger.w('OpenAI API unavailable ($statusCode). Returning fallback restaurants.');
        return Right(_generateFallbackRestaurants(destination, cuisineType));
      }
      return Left(NetworkFailure(message: 'Restaurant recommendations failed: ${e.message}'));
    } catch (e) {
      logger.e('Error: $e');
      return Right(_generateFallbackRestaurants(destination, cuisineType));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getActivitySuggestions({
    required String destination,
    required List<String> preferences,
    required double budget,
  }) async {
    try {
      final prompt = '''Suggest 5 unique activities in $destination for someone interested in ${preferences.join(', ')}.
Budget per activity: \$$budget.

For each activity provide:
{
  "title": "...",
  "category": "...",
  "duration": "X hours",
  "price": number,
  "rating": 4.0-5.0,
  "description": "...",
  "bestFor": "..."
}

Format as a JSON array of activity objects.''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a travel activity expert. Provide activity suggestions in valid JSON format only.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'] as String;
        final jsonStr = _extractJsonFromResponse(content);
        final activities = _parseJsonArray(jsonStr);
        logger.i('Activity suggestions fetched for $destination');
        return Right(List<Map<String, dynamic>>.from(activities));
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('Dio Error: $e');
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 429 || (statusCode != null && statusCode >= 500)) {
        logger.w('OpenAI API unavailable ($statusCode). Returning fallback activities.');
        return Right(_generateFallbackActivities(destination, preferences, budget));
      }
      return Left(NetworkFailure(message: 'Activity suggestions failed: ${e.message}'));
    } catch (e) {
      logger.e('Error: $e');
      return Right(_generateFallbackActivities(destination, preferences, budget));
    }
  }

  // Helper methods
  String _extractJsonFromResponse(String content) {
    try {
      // Try to find JSON in the response
      final jsonStart = content.indexOf('[');
      final jsonEnd = content.lastIndexOf(']');
      
      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        return content.substring(jsonStart, jsonEnd + 1);
      }
      
      final objStart = content.indexOf('{');
      final objEnd = content.lastIndexOf('}');
      if (objStart != -1 && objEnd != -1 && objEnd > objStart) {
        return content.substring(objStart, objEnd + 1);
      }
      
      return content;
    } catch (e) {
      logger.e('Error extracting JSON: $e');
      return content;
    }
  }

  List<dynamic> _parseJsonArray(String jsonStr) {
    try {
      return jsonDecode(jsonStr) as List<dynamic>;
    } catch (e) {
      logger.e('Error parsing JSON array: $e');
      return [];
    }
  }

  Map<String, dynamic> _parseJson(String jsonStr) {
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error parsing JSON: $e');
      return {};
    }
  }

  // Fallback recommendations when API is unavailable
  List<Map<String, dynamic>> _generateFallbackDestinations(
    String preferences,
    int numberOfDays,
    double budget,
  ) {
    logger.w('Using fallback recommendations due to API unavailability');
    return [
      {
        'name': 'Barcelona, Spain',
        'reason': 'Perfect for art, architecture, and beach lovers',
        'bestTime': 'April-May or September-October',
        'estimatedCost': budget * 0.8,
        'highlights': ['Sagrada Familia', 'Park Güell', 'Gothic Quarter', 'Beaches'],
      },
      {
        'name': 'Tokyo, Japan',
        'reason': 'Blend of ancient traditions and modern technology',
        'bestTime': 'March-May or September-November',
        'estimatedCost': budget * 0.9,
        'highlights': ['Temples', 'Street Food', 'Shopping', 'Nightlife'],
      },
      {
        'name': 'Paris, France',
        'reason': 'Classic romantic destination with world-class museums',
        'bestTime': 'April-June or September-October',
        'estimatedCost': budget,
        'highlights': ['Eiffel Tower', 'Louvre', 'Cafés', 'Montmartre'],
      },
      {
        'name': 'New York, USA',
        'reason': 'The city that never sleeps with endless entertainment',
        'bestTime': 'May-June or September-October',
        'estimatedCost': budget * 1.1,
        'highlights': ['Central Park', 'Times Square', 'Museums', 'Broadway'],
      },
      {
        'name': 'Bangkok, Thailand',
        'reason': 'Affordable luxury with amazing street food and temples',
        'bestTime': 'November-February',
        'estimatedCost': budget * 0.5,
        'highlights': ['Grand Palace', 'Floating Markets', 'Street Food', 'Temples'],
      },
    ];
  }

  Map<String, dynamic> _generateFallbackItinerary(
    String destination,
    int numberOfDays,
    List<String> interests,
  ) {
    final days = <Map<String, dynamic>>[];
    for (int i = 1; i <= numberOfDays; i++) {
      days.add({
        'day': i,
        'theme': i == 1 ? 'Arrival & Orientation' : i == numberOfDays ? 'Relaxation' : 'Exploration',
        'activities': [
          'Visit local attractions',
          'Experience local cuisine',
          'Shopping or exploration',
        ],
        'meals': {
          'breakfast': 'Local café',
          'lunch': 'Street food or restaurant',
          'dinner': 'Fine dining spot',
        },
      });
    }
    return {
      'destination': destination,
      'duration': numberOfDays,
      'interests': interests,
      'itinerary': days,
      'estimatedBudget': numberOfDays * 150,
    };
  }

  List<String> _generateFallbackLocalTips(String destination) {
    return [
      'Download offline maps before arriving',
      'Learn basic local phrases - locals appreciate the effort',
      'Public transportation is usually the most affordable option',
      'Eat where the locals eat for authentic and cheap meals',
      'Visit museums on free admission days to save money',
      'Early morning visits to popular sites avoid crowds',
      'Book tours through your hotel for better deals',
      'Keep small cash for street vendors and markets',
      'Respect local customs and dress codes in religious sites',
      'Use public Wi-Fi cautiously - consider a VPN for sensitive data',
    ];
  }

  List<Map<String, dynamic>> _generateFallbackRestaurants(
    String destination,
    String cuisineType,
  ) {
    return [
      {
        'name': '$destination Kitchen House',
        'cuisine': cuisineType,
        'rating': 4.8,
        'reviews': 2150,
        'priceRange': '\$\$\$',
        'specialty': 'Traditional ${cuisineType.toLowerCase()} with modern twist',
        'address': 'Downtown area',
      },
      {
        'name': 'The Global $cuisineType Bar',
        'cuisine': cuisineType,
        'rating': 4.6,
        'reviews': 1890,
        'priceRange': '\$\$',
        'specialty': 'Fusion ${cuisineType.toLowerCase()} dishes',
        'address': 'Central district',
      },
      {
        'name': 'Local Flavors Bistro',
        'cuisine': cuisineType,
        'rating': 4.7,
        'reviews': 1650,
        'priceRange': '\$\$\$',
        'specialty': 'Authentic family recipes',
        'address': 'Historic quarter',
      },
      {
        'name': 'Street $cuisineType Express',
        'cuisine': cuisineType,
        'rating': 4.4,
        'reviews': 3200,
        'priceRange': '\$',
        'specialty': 'Quick bites and street food',
        'address': 'Market area',
      },
      {
        'name': 'Fine Dining $destination',
        'cuisine': cuisineType,
        'rating': 4.9,
        'reviews': 980,
        'priceRange': '\$\$\$\$',
        'specialty': 'Michelin-standard experience',
        'address': 'Luxury district',
      },
    ];
  }

  List<Map<String, dynamic>> _generateFallbackActivities(
    String destination,
    List<String> preferences,
    double budget,
  ) {
    return [
      {
        'title': 'Guided City Walking Tour',
        'category': 'Sightseeing',
        'duration': '3 hours',
        'price': 45,
        'rating': 4.8,
        'description': 'Comprehensive tour covering major landmarks and hidden gems',
        'bestFor': 'History and culture enthusiasts',
      },
      {
        'title': 'Culinary Street Food Tour',
        'category': 'Food & Dining',
        'duration': '2.5 hours',
        'price': 55,
        'rating': 4.9,
        'description': 'Taste authentic street food from local vendors',
        'bestFor': 'Food lovers',
      },
      {
        'title': 'Museum & Art Gallery Pass',
        'category': 'Culture',
        'duration': '4 hours',
        'price': 65,
        'rating': 4.7,
        'description': 'Skip-the-line access to major museums and galleries',
        'bestFor': 'Art and history buffs',
      },
      {
        'title': 'Adventure Hiking Experience',
        'category': 'Adventure',
        'duration': '5 hours',
        'price': 75,
        'rating': 4.8,
        'description': 'Guided hike with scenic views and local wildlife',
        'bestFor': 'Nature and adventure seekers',
      },
      {
        'title': 'Evening Nightlife & Entertainment',
        'category': 'Nightlife',
        'duration': '3 hours',
        'price': 60,
        'rating': 4.6,
        'description': 'Experience local nightclubs and entertainment venues',
        'bestFor': 'Party enthusiasts',
      },
    ];
  }
}
