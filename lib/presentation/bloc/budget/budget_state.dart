import 'package:equatable/equatable.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/domain/usecases/budget_optimizer.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetOptimizeSuccess extends BudgetState {
  final TripBudgetBreakdown breakdown;
  final double percentageUsed;
  final double remaining;

  const BudgetOptimizeSuccess({
    required this.breakdown,
    required this.percentageUsed,
    required this.remaining,
  });

  @override
  List<Object?> get props => [breakdown, percentageUsed, remaining];
}

class DealDetectionSuccess extends BudgetState {
  final List<DealInfo> deals;
  final int totalDealsFound;

  const DealDetectionSuccess({
    required this.deals,
    required this.totalDealsFound,
  });

  @override
  List<Object?> get props => [deals, totalDealsFound];
}

class TripComparisonSuccess extends BudgetState {
  final Map<String, dynamic> comparisonResult;
  final Map<String, dynamic>? cheapestOption;
  final double averageCost;

  const TripComparisonSuccess({
    required this.comparisonResult,
    this.cheapestOption,
    required this.averageCost,
  });

  @override
  List<Object?> get props => [comparisonResult, cheapestOption, averageCost];
}

class RecommendationsSuccess extends BudgetState {
  final List<String> recommendations;

  const RecommendationsSuccess({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class BudgetFailure extends BudgetState {
  final Failure failure;

  const BudgetFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class NoDealFound extends BudgetState {
  final String message;

  const NoDealFound({this.message = 'No deals found'});

  @override
  List<Object?> get props => [message];
}
