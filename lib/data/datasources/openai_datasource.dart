import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class OpenAIDataSource {
  final Dio dio;
  final Logger logger;
  
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-3.5-turbo';

  OpenAIDataSource({required this.dio, required this.logger}) {
    _setupDio();
  }

  void _setupDio() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY not found in .env file');
    }

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

  /// Get travel recommendations based on user preferences
  Future<String> getTravelRecommendations({
    required String destination,
    required String budget,
    required String duration,
    required String interests,
    required String travelStyle,
  }) async {
    try {
      final prompt = _buildRecommendationPrompt(
        destination: destination,
        budget: budget,
        duration: duration,
        interests: interests,
        travelStyle: travelStyle,
      );

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': '''You are an expert travel advisor. Provide personalized travel recommendations 
with specific hotel suggestions, activity recommendations, and dining suggestions. 
Format your response in a structured way with clear sections.'''
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
        final message = response.data['choices'][0]['message']['content'] as String;
        logger.i('OpenAI Recommendation: $message');
        return message;
      } else {
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('OpenAI Dio Error: $e');
      throw Exception('Failed to fetch recommendations: ${e.message}');
    } catch (e) {
      logger.e('OpenAI Error: $e');
      rethrow;
    }
  }

  /// Get activity recommendations for a specific destination
  Future<String> getActivityRecommendations({
    required String destination,
    required String interests,
    required String duration,
  }) async {
    try {
      final prompt = '''Suggest 5 must-do activities in $destination for someone interested in: $interests.
Available time: $duration.
Include estimated duration, cost range, and best time to visit for each activity.''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert travel guide. Provide specific, actionable activity recommendations.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.8,
          'max_tokens': 800,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get activity recommendations');
      }
    } on DioException catch (e) {
      logger.e('OpenAI Dio Error: $e');
      throw Exception('Failed to fetch activity recommendations: ${e.message}');
    } catch (e) {
      logger.e('OpenAI Error: $e');
      rethrow;
    }
  }

  /// Get dining recommendations for a destination
  Future<String> getDiningRecommendations({
    required String destination,
    required String cuisine,
    required String budget,
  }) async {
    try {
      final prompt = '''Recommend 5 best restaurants in $destination for $cuisine cuisine.
Budget per person: $budget.
Include restaurant name, cuisine type, estimated price, and specialty dishes.''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a food and dining expert. Provide specific restaurant recommendations with details.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 800,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get dining recommendations');
      }
    } on DioException catch (e) {
      logger.e('OpenAI Dio Error: $e');
      throw Exception('Failed to fetch dining recommendations: ${e.message}');
    } catch (e) {
      logger.e('OpenAI Error: $e');
      rethrow;
    }
  }

  /// Get itinerary planning suggestions
  Future<String> generateItinerary({
    required String destination,
    required int days,
    required String interests,
    required String pace,
  }) async {
    try {
      final prompt = '''Create a detailed $days-day itinerary for $destination.
Travel style: $pace paced
Interests: $interests

Format the response as a day-by-day breakdown with:
- Morning activity
- Lunch recommendation
- Afternoon activity
- Evening activity/dining
- Travel tips''';

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert travel planner. Create detailed, practical itineraries with specific recommendations.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.8,
          'max_tokens': 1500,
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to generate itinerary');
      }
    } on DioException catch (e) {
      logger.e('OpenAI Dio Error: $e');
      throw Exception('Failed to generate itinerary: ${e.message}');
    } catch (e) {
      logger.e('OpenAI Error: $e');
      rethrow;
    }
  }

  /// Build comprehensive recommendation prompt
  String _buildRecommendationPrompt({
    required String destination,
    required String budget,
    required String duration,
    required String interests,
    required String travelStyle,
  }) {
    return '''Please provide comprehensive travel recommendations for:
Destination: $destination
Duration: $duration
Budget: $budget per person
Interests: $interests
Travel Style: $travelStyle

Please include:
1. Best time to visit and weather
2. Getting around (transportation options)
3. Top 5 recommended hotels with estimated rates
4. Top 5 must-see attractions
5. Best restaurants (mix of price ranges)
6. Local tips and cultural insights
7. Budget breakdown suggestions
8. Safety and practical information''';
  }
}
