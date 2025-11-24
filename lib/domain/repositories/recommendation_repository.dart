import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/travel_recommendation.dart';

abstract class RecommendationRepository {
  Future<Either<Failure, TravelRecommendation>> getTravelRecommendations({
    required String destination,
    required String budget,
    required String duration,
    required String interests,
    required String travelStyle,
  });

  Future<Either<Failure, TravelRecommendation>> getActivityRecommendations({
    required String destination,
    required String interests,
    required String duration,
  });

  Future<Either<Failure, TravelRecommendation>> getDiningRecommendations({
    required String destination,
    required String cuisine,
    required String budget,
  });

  Future<Either<Failure, TravelRecommendation>> generateItinerary({
    required String destination,
    required int days,
    required String interests,
    required String pace,
  });
}
