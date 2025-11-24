import 'package:equatable/equatable.dart';

abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object?> get props => [];
}

class GetRecommendationsRequested extends RecommendationEvent {
  final String destination;
  final int numberOfDays;
  final double budget;
  final List<String> preferences;

  const GetRecommendationsRequested({
    required this.destination,
    required this.numberOfDays,
    required this.budget,
    required this.preferences,
  });

  @override
  List<Object?> get props => [destination, numberOfDays, budget, preferences];
}

class GetPersonalizedRecommendationsRequested extends RecommendationEvent {
  final String userId;

  const GetPersonalizedRecommendationsRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshRecommendations extends RecommendationEvent {
  const RefreshRecommendations();
}

class SaveRecommendationToTrip extends RecommendationEvent {
  final String recommendationId;
  final String tripId;

  const SaveRecommendationToTrip({
    required this.recommendationId,
    required this.tripId,
  });

  @override
  List<Object?> get props => [recommendationId, tripId];
}
