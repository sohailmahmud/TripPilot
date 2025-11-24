import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/travel_recommendation.dart';
import '../../../domain/usecases/recommendation_usecases.dart';

// Events
abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object?> get props => [];
}

class GetTravelRecommendationsEvent extends RecommendationEvent {
  final String destination;
  final String budget;
  final String duration;
  final String interests;
  final String travelStyle;

  const GetTravelRecommendationsEvent({
    required this.destination,
    required this.budget,
    required this.duration,
    required this.interests,
    required this.travelStyle,
  });

  @override
  List<Object?> get props => [destination, budget, duration, interests, travelStyle];
}

class GetActivityRecommendationsEvent extends RecommendationEvent {
  final String destination;
  final String interests;
  final String duration;

  const GetActivityRecommendationsEvent({
    required this.destination,
    required this.interests,
    required this.duration,
  });

  @override
  List<Object?> get props => [destination, interests, duration];
}

class GetDiningRecommendationsEvent extends RecommendationEvent {
  final String destination;
  final String cuisine;
  final String budget;

  const GetDiningRecommendationsEvent({
    required this.destination,
    required this.cuisine,
    required this.budget,
  });

  @override
  List<Object?> get props => [destination, cuisine, budget];
}

class GenerateItineraryEvent extends RecommendationEvent {
  final String destination;
  final int days;
  final String interests;
  final String pace;

  const GenerateItineraryEvent({
    required this.destination,
    required this.days,
    required this.interests,
    required this.pace,
  });

  @override
  List<Object?> get props => [destination, days, interests, pace];
}

// States
abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

class RecommendationInitial extends RecommendationState {
  const RecommendationInitial();
}

class RecommendationLoading extends RecommendationState {
  final String type; // 'travel', 'activity', 'dining', 'itinerary'

  const RecommendationLoading({required this.type});

  @override
  List<Object?> get props => [type];
}

class RecommendationSuccess extends RecommendationState {
  final TravelRecommendation recommendation;

  const RecommendationSuccess({required this.recommendation});

  @override
  List<Object?> get props => [recommendation];
}

class RecommendationFailure extends RecommendationState {
  final String message;

  const RecommendationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class RecommendationBloc extends Bloc<RecommendationEvent, RecommendationState> {
  final GetTravelRecommendationsUseCase getTravelRecommendationsUseCase;
  final GetActivityRecommendationsUseCase getActivityRecommendationsUseCase;
  final GetDiningRecommendationsUseCase getDiningRecommendationsUseCase;
  final GenerateItineraryUseCase generateItineraryUseCase;

  RecommendationBloc({
    required this.getTravelRecommendationsUseCase,
    required this.getActivityRecommendationsUseCase,
    required this.getDiningRecommendationsUseCase,
    required this.generateItineraryUseCase,
  }) : super(const RecommendationInitial()) {
    on<GetTravelRecommendationsEvent>(_onGetTravelRecommendations);
    on<GetActivityRecommendationsEvent>(_onGetActivityRecommendations);
    on<GetDiningRecommendationsEvent>(_onGetDiningRecommendations);
    on<GenerateItineraryEvent>(_onGenerateItinerary);
  }

  Future<void> _onGetTravelRecommendations(
    GetTravelRecommendationsEvent event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(const RecommendationLoading(type: 'travel'));

    final result = await getTravelRecommendationsUseCase.call(
      destination: event.destination,
      budget: event.budget,
      duration: event.duration,
      interests: event.interests,
      travelStyle: event.travelStyle,
    );

    result.fold(
      (failure) => emit(RecommendationFailure(message: failure.message)),
      (recommendation) => emit(RecommendationSuccess(recommendation: recommendation)),
    );
  }

  Future<void> _onGetActivityRecommendations(
    GetActivityRecommendationsEvent event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(const RecommendationLoading(type: 'activity'));

    final result = await getActivityRecommendationsUseCase.call(
      destination: event.destination,
      interests: event.interests,
      duration: event.duration,
    );

    result.fold(
      (failure) => emit(RecommendationFailure(message: failure.message)),
      (recommendation) => emit(RecommendationSuccess(recommendation: recommendation)),
    );
  }

  Future<void> _onGetDiningRecommendations(
    GetDiningRecommendationsEvent event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(const RecommendationLoading(type: 'dining'));

    final result = await getDiningRecommendationsUseCase.call(
      destination: event.destination,
      cuisine: event.cuisine,
      budget: event.budget,
    );

    result.fold(
      (failure) => emit(RecommendationFailure(message: failure.message)),
      (recommendation) => emit(RecommendationSuccess(recommendation: recommendation)),
    );
  }

  Future<void> _onGenerateItinerary(
    GenerateItineraryEvent event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(const RecommendationLoading(type: 'itinerary'));

    final result = await generateItineraryUseCase.call(
      destination: event.destination,
      days: event.days,
      interests: event.interests,
      pace: event.pace,
    );

    result.fold(
      (failure) => emit(RecommendationFailure(message: failure.message)),
      (recommendation) => emit(RecommendationSuccess(recommendation: recommendation)),
    );
  }
}
