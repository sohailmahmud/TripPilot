import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_pilot/domain/usecases/budget_optimizer.dart';
import 'package:trip_pilot/presentation/bloc/budget/budget_event.dart';
import 'package:trip_pilot/presentation/bloc/budget/budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(const BudgetInitial()) {
    on<OptimizeBudgetRequested>(_onOptimizeBudgetRequested);
    on<DetectDealsRequested>(_onDetectDealsRequested);
    on<CompareTripOptionsRequested>(_onCompareTripOptionsRequested);
    on<GetBudgetRecommendationsRequested>(_onGetBudgetRecommendationsRequested);
    on<ClearBudgetResults>(_onClearBudgetResults);
  }

  Future<void> _onOptimizeBudgetRequested(
    OptimizeBudgetRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    try {
      final breakdown = BudgetOptimizer.optimizeBudget(
        totalBudget: event.totalBudget,
        numberOfDays: event.numberOfDays,
        numberOfPeople: event.numberOfPeople,
        outboundFlight: event.outboundFlight,
        returnFlight: event.returnFlight,
        hotels: event.hotels,
        activities: event.activities,
      );

      emit(BudgetOptimizeSuccess(
        breakdown: breakdown,
        percentageUsed: breakdown.percentageUsed,
        remaining: breakdown.remaining,
      ));
    } catch (e) {
      emit(NoDealFound(message: 'Budget optimization failed: ${e.toString()}'));
    }
  }

  Future<void> _onDetectDealsRequested(
    DetectDealsRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    try {
      final deals = <DealInfo>[];

      if (event.flights != null && event.flights!.isNotEmpty) {
        deals.addAll(BudgetOptimizer.detectFlightDeals(event.flights!));
      }

      if (event.hotels != null && event.hotels!.isNotEmpty) {
        deals.addAll(BudgetOptimizer.detectHotelDeals(event.hotels!));
      }

      if (event.activities != null && event.activities!.isNotEmpty) {
        deals.addAll(BudgetOptimizer.detectActivityDeals(event.activities!));
      }

      if (deals.isEmpty) {
        emit(const NoDealFound());
      } else {
        emit(DealDetectionSuccess(
          deals: deals,
          totalDealsFound: deals.length,
        ));
      }
    } catch (e) {
      emit(NoDealFound(message: 'Deal detection failed: ${e.toString()}'));
    }
  }

  Future<void> _onCompareTripOptionsRequested(
    CompareTripOptionsRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    try {
      final comparison = BudgetOptimizer.compareTripOptions(
        flights: event.flights,
        hotels: event.hotels,
        activities: event.activities,
        numberOfDays: event.numberOfDays,
        numberOfPeople: event.numberOfPeople,
      );

      emit(TripComparisonSuccess(
        comparisonResult: comparison,
        cheapestOption: comparison['cheapestOption'] as Map<String, dynamic>?,
        averageCost: comparison['averageCost'] as double,
      ));
    } catch (e) {
      emit(NoDealFound(message: 'Trip comparison failed: ${e.toString()}'));
    }
  }

  Future<void> _onGetBudgetRecommendationsRequested(
    GetBudgetRecommendationsRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    try {
      // Reconstruct breakdown from map
      final breakdown = TripBudgetBreakdown(
        totalBudget: event.breakdown['totalBudget'] as double,
        flightCost: event.breakdown['flightCost'] as double,
        hotelCost: event.breakdown['hotelCost'] as double,
        activitiesCost: event.breakdown['activitiesCost'] as double,
        foodEstimate: event.breakdown['foodEstimate'] as double,
        transportEstimate: event.breakdown['transportEstimate'] as double,
        contingency: event.breakdown['contingency'] as double,
      );

      final recommendations = BudgetOptimizer.getBudgetRecommendations(
        budget: event.budget,
        breakdown: breakdown,
        deals: const [],
      );

      emit(RecommendationsSuccess(recommendations: recommendations));
    } catch (e) {
      emit(NoDealFound(message: 'Recommendations failed: ${e.toString()}'));
    }
  }

  Future<void> _onClearBudgetResults(
    ClearBudgetResults event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetInitial());
  }
}
