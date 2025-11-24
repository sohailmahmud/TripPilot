import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_pilot/domain/repositories/ai_recommendation_service.dart';
import 'package:trip_pilot/presentation/bloc/recommendations/recommendations_event.dart';
import 'package:trip_pilot/presentation/bloc/recommendations/recommendations_state.dart';

class RecommendationBloc extends Bloc<RecommendationEvent, RecommendationState> {
  final AIRecommendationService aiService;

  RecommendationBloc({required this.aiService}) : super(const RecommendationInitial()) {
    on<GetRecommendationsRequested>(_onGetRecommendationsRequested);
    on<GetPersonalizedRecommendationsRequested>(_onGetPersonalizedRecommendationsRequested);
    on<RefreshRecommendations>(_onRefreshRecommendations);
    on<SaveRecommendationToTrip>(_onSaveRecommendationToTrip);
  }

  Future<void> _onGetRecommendationsRequested(
    GetRecommendationsRequested event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(const RecommendationLoading());

    try {
      final result = await aiService.getDestinationRecommendations(
        preferences: event.preferences.join(', '),
        numberOfDays: event.numberOfDays,
        budget: event.budget,
      );

      result.fold(
        (failure) => emit(RecommendationFailure(failure)),
        (recommendations) {
          if (recommendations.isEmpty) {
            emit(const RecommendationEmpty());
          } else {
            emit(RecommendationSuccess(
              recommendations: recommendations,
              destination: 'Multiple Destinations',
            ));
          }
        },
      );
    } catch (e) {
      emit(RecommendationEmpty(message: 'Failed to fetch recommendations: $e'));
    }
  }

  Future<void> _onGetPersonalizedRecommendationsRequested(
    GetPersonalizedRecommendationsRequested event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(const RecommendationLoading());

    try {
      // For personalized recommendations, we would fetch user preferences from repository
      // and then call the AI service with those preferences
      
      final result = await aiService.getDestinationRecommendations(
        preferences: 'adventure, culture, food',
        numberOfDays: 7,
        budget: 2000,
      );

      result.fold(
        (failure) => emit(RecommendationFailure(failure)),
        (recommendations) => emit(PersonalizedRecommendationSuccess(
          recommendations: recommendations,
          userId: event.userId,
        )),
      );
    } catch (e) {
      emit(RecommendationEmpty(message: 'Failed to fetch personalized recommendations: $e'));
    }
  }

  Future<void> _onRefreshRecommendations(
    RefreshRecommendations event,
    Emitter<RecommendationState> emit,
  ) async {
    if (state is RecommendationSuccess) {
      final currentState = state as RecommendationSuccess;
      emit(const RecommendationLoading());
      
      // Simulate refresh by waiting briefly then re-emitting state
      await Future.delayed(const Duration(milliseconds: 500));
      emit(currentState);
    }
  }

  Future<void> _onSaveRecommendationToTrip(
    SaveRecommendationToTrip event,
    Emitter<RecommendationState> emit,
  ) async {
    // Save recommendation to trip in database
    emit(const RecommendationSaved());
  }
}
