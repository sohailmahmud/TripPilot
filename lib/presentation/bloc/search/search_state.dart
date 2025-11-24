import 'package:equatable/equatable.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  final String searchType;

  const SearchLoading({this.searchType = 'flights'});

  @override
  List<Object?> get props => [searchType];
}

class FlightsSearchSuccess extends SearchState {
  final List<Flight> flights;
  final int totalResults;

  const FlightsSearchSuccess({
    required this.flights,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [flights, totalResults];
}

class HotelsSearchSuccess extends SearchState {
  final List<Hotel> hotels;
  final int totalResults;

  const HotelsSearchSuccess({
    required this.hotels,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [hotels, totalResults];
}

class ActivitiesSearchSuccess extends SearchState {
  final List<Activity> activities;
  final int totalResults;

  const ActivitiesSearchSuccess({
    required this.activities,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [activities, totalResults];
}

class SearchFailure extends SearchState {
  final Failure failure;

  const SearchFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class SearchEmpty extends SearchState {
  final String message;

  const SearchEmpty({this.message = 'No results found'});

  @override
  List<Object?> get props => [message];
}
