import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';

/// AI Recommendation Service Interface
abstract class AIRecommendationService {
  /// Get personalized destination recommendations
  Future<Either<Failure, List<Map<String, dynamic>>>> getDestinationRecommendations({
    required String preferences,
    required int numberOfDays,
    required double budget,
  });

  /// Generate an itinerary for a destination
  Future<Either<Failure, Map<String, dynamic>>> generateItinerary({
    required String destination,
    required int numberOfDays,
    required List<String> interests,
  });

  /// Get local tips and recommendations
  Future<Either<Failure, List<String>>> getLocalTips({
    required String destination,
  });

  /// Get restaurant recommendations
  Future<Either<Failure, List<Map<String, dynamic>>>> getRestaurantRecommendations({
    required String destination,
    required String cuisineType,
  });

  /// Get activity suggestions based on preferences
  Future<Either<Failure, List<Map<String, dynamic>>>> getActivitySuggestions({
    required String destination,
    required List<String> preferences,
    required double budget,
  });
}
