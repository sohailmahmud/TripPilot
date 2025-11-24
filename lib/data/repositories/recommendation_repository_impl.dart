import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/travel_recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/openai_datasource.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final OpenAIDataSource openAIDataSource;
  final Logger logger;

  RecommendationRepositoryImpl({
    required this.openAIDataSource,
    required this.logger,
  });

  @override
  Future<Either<Failure, TravelRecommendation>> getTravelRecommendations({
    required String destination,
    required String budget,
    required String duration,
    required String interests,
    required String travelStyle,
  }) async {
    try {
      logger.i('Fetching travel recommendations for $destination');
      final recommendation = await openAIDataSource.getTravelRecommendations(
        destination: destination,
        budget: budget,
        duration: duration,
        interests: interests,
        travelStyle: travelStyle,
      );

      return Right(TravelRecommendation(
        destination: destination,
        recommendation: recommendation,
        generatedAt: DateTime.now(),
        type: 'general',
      ));
    } catch (e) {
      logger.e('Error fetching travel recommendations: $e');
      return Left(ServerFailure('Failed to get recommendations: $e'));
    }
  }

  @override
  Future<Either<Failure, TravelRecommendation>> getActivityRecommendations({
    required String destination,
    required String interests,
    required String duration,
  }) async {
    try {
      logger.i('Fetching activity recommendations for $destination');
      final recommendation = await openAIDataSource.getActivityRecommendations(
        destination: destination,
        interests: interests,
        duration: duration,
      );

      return Right(TravelRecommendation(
        destination: destination,
        recommendation: recommendation,
        generatedAt: DateTime.now(),
        type: 'activity',
      ));
    } catch (e) {
      logger.e('Error fetching activity recommendations: $e');
      return Left(ServerFailure('Failed to get activity recommendations: $e'));
    }
  }

  @override
  Future<Either<Failure, TravelRecommendation>> getDiningRecommendations({
    required String destination,
    required String cuisine,
    required String budget,
  }) async {
    try {
      logger.i('Fetching dining recommendations for $destination');
      final recommendation = await openAIDataSource.getDiningRecommendations(
        destination: destination,
        cuisine: cuisine,
        budget: budget,
      );

      return Right(TravelRecommendation(
        destination: destination,
        recommendation: recommendation,
        generatedAt: DateTime.now(),
        type: 'dining',
      ));
    } catch (e) {
      logger.e('Error fetching dining recommendations: $e');
      return Left(ServerFailure('Failed to get dining recommendations: $e'));
    }
  }

  @override
  Future<Either<Failure, TravelRecommendation>> generateItinerary({
    required String destination,
    required int days,
    required String interests,
    required String pace,
  }) async {
    try {
      logger.i('Generating itinerary for $destination');
      final itinerary = await openAIDataSource.generateItinerary(
        destination: destination,
        days: days,
        interests: interests,
        pace: pace,
      );

      return Right(TravelRecommendation(
        destination: destination,
        recommendation: itinerary,
        generatedAt: DateTime.now(),
        type: 'itinerary',
      ));
    } catch (e) {
      logger.e('Error generating itinerary: $e');
      return Left(ServerFailure('Failed to generate itinerary: $e'));
    }
  }
}
