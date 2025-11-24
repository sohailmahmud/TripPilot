import 'package:equatable/equatable.dart';
import 'package:trip_pilot/core/errors/failures.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

class RecommendationInitial extends RecommendationState {
  const RecommendationInitial();
}

class RecommendationLoading extends RecommendationState {
  const RecommendationLoading();
}

class RecommendationSuccess extends RecommendationState {
  final List<Map<String, dynamic>> recommendations;
  final String destination;

  const RecommendationSuccess({
    required this.recommendations,
    required this.destination,
  });

  @override
  List<Object?> get props => [recommendations, destination];
}

class PersonalizedRecommendationSuccess extends RecommendationState {
  final List<Map<String, dynamic>> recommendations;
  final String userId;

  const PersonalizedRecommendationSuccess({
    required this.recommendations,
    required this.userId,
  });

  @override
  List<Object?> get props => [recommendations, userId];
}

class RecommendationFailure extends RecommendationState {
  final Failure failure;

  const RecommendationFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class RecommendationEmpty extends RecommendationState {
  final String message;

  const RecommendationEmpty({this.message = 'No recommendations available'});

  @override
  List<Object?> get props => [message];
}

class RecommendationSaved extends RecommendationState {
  final String message;

  const RecommendationSaved({this.message = 'Recommendation saved to trip'});

  @override
  List<Object?> get props => [message];
}
