import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/travel_recommendation.dart';
import '../repositories/recommendation_repository.dart';

class GetTravelRecommendationsUseCase {
  final RecommendationRepository repository;

  GetTravelRecommendationsUseCase({required this.repository});

  Future<Either<Failure, TravelRecommendation>> call({
    required String destination,
    required String budget,
    required String duration,
    required String interests,
    required String travelStyle,
  }) async {
    return await repository.getTravelRecommendations(
      destination: destination,
      budget: budget,
      duration: duration,
      interests: interests,
      travelStyle: travelStyle,
    );
  }
}

class GetActivityRecommendationsUseCase {
  final RecommendationRepository repository;

  GetActivityRecommendationsUseCase({required this.repository});

  Future<Either<Failure, TravelRecommendation>> call({
    required String destination,
    required String interests,
    required String duration,
  }) async {
    return await repository.getActivityRecommendations(
      destination: destination,
      interests: interests,
      duration: duration,
    );
  }
}

class GetDiningRecommendationsUseCase {
  final RecommendationRepository repository;

  GetDiningRecommendationsUseCase({required this.repository});

  Future<Either<Failure, TravelRecommendation>> call({
    required String destination,
    required String cuisine,
    required String budget,
  }) async {
    return await repository.getDiningRecommendations(
      destination: destination,
      cuisine: cuisine,
      budget: budget,
    );
  }
}

class GenerateItineraryUseCase {
  final RecommendationRepository repository;

  GenerateItineraryUseCase({required this.repository});

  Future<Either<Failure, TravelRecommendation>> call({
    required String destination,
    required int days,
    required String interests,
    required String pace,
  }) async {
    return await repository.generateItinerary(
      destination: destination,
      days: days,
      interests: interests,
      pace: pace,
    );
  }
}
