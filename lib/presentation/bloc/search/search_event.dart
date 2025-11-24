import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchFlightsRequested extends SearchEvent {
  final String departureCity;
  final String arrivalCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int numberOfPassengers;

  const SearchFlightsRequested({
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
    this.returnDate,
    this.numberOfPassengers = 1,
  });

  @override
  List<Object?> get props => [
    departureCity,
    arrivalCity,
    departureDate,
    returnDate,
    numberOfPassengers,
  ];
}

class SearchHotelsRequested extends SearchEvent {
  final String city;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;

  const SearchHotelsRequested({
    required this.city,
    required this.checkInDate,
    required this.checkOutDate,
    this.numberOfGuests = 1,
  });

  @override
  List<Object?> get props => [
    city,
    checkInDate,
    checkOutDate,
    numberOfGuests,
  ];
}

class SearchActivitiesRequested extends SearchEvent {
  final String city;
  final String? category;

  const SearchActivitiesRequested({
    required this.city,
    this.category,
  });

  @override
  List<Object?> get props => [city, category];
}

class ClearSearchResults extends SearchEvent {
  const ClearSearchResults();
}

class ApplyFilters extends SearchEvent {
  final double? maxPrice;
  final double? minRating;
  final List<String>? airlines;

  const ApplyFilters({
    this.maxPrice,
    this.minRating,
    this.airlines,
  });

  @override
  List<Object?> get props => [maxPrice, minRating, airlines];
}
