import 'package:equatable/equatable.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class OptimizeBudgetRequested extends BudgetEvent {
  final double totalBudget;
  final int numberOfDays;
  final int numberOfPeople;
  final Flight? outboundFlight;
  final Flight? returnFlight;
  final List<Hotel>? hotels;
  final List<Activity>? activities;

  const OptimizeBudgetRequested({
    required this.totalBudget,
    required this.numberOfDays,
    required this.numberOfPeople,
    this.outboundFlight,
    this.returnFlight,
    this.hotels,
    this.activities,
  });

  @override
  List<Object?> get props => [
    totalBudget,
    numberOfDays,
    numberOfPeople,
    outboundFlight,
    returnFlight,
    hotels,
    activities,
  ];
}

class DetectDealsRequested extends BudgetEvent {
  final List<Flight>? flights;
  final List<Hotel>? hotels;
  final List<Activity>? activities;

  const DetectDealsRequested({
    this.flights,
    this.hotels,
    this.activities,
  });

  @override
  List<Object?> get props => [flights, hotels, activities];
}

class CompareTripOptionsRequested extends BudgetEvent {
  final List<Flight> flights;
  final List<Hotel> hotels;
  final List<Activity> activities;
  final int numberOfDays;
  final int numberOfPeople;

  const CompareTripOptionsRequested({
    required this.flights,
    required this.hotels,
    required this.activities,
    required this.numberOfDays,
    required this.numberOfPeople,
  });

  @override
  List<Object?> get props => [
    flights,
    hotels,
    activities,
    numberOfDays,
    numberOfPeople,
  ];
}

class GetBudgetRecommendationsRequested extends BudgetEvent {
  final double budget;
  final Map<String, dynamic> breakdown;

  const GetBudgetRecommendationsRequested({
    required this.budget,
    required this.breakdown,
  });

  @override
  List<Object?> get props => [budget, breakdown];
}

class ClearBudgetResults extends BudgetEvent {
  const ClearBudgetResults();
}
