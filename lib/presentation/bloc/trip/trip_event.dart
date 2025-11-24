import 'package:equatable/equatable.dart';
import 'package:trip_pilot/domain/entities/trip.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class FetchTripsRequested extends TripEvent {
  const FetchTripsRequested();
}

class FetchTripByIdRequested extends TripEvent {
  final String tripId;

  const FetchTripByIdRequested({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class CreateTripRequested extends TripEvent {
  final Trip trip;

  const CreateTripRequested({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class UpdateTripRequested extends TripEvent {
  final String tripId;
  final Trip trip;

  const UpdateTripRequested({
    required this.tripId,
    required this.trip,
  });

  @override
  List<Object?> get props => [tripId, trip];
}

class DeleteTripRequested extends TripEvent {
  final String tripId;

  const DeleteTripRequested({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class SearchTripsRequested extends TripEvent {
  final String query;

  const SearchTripsRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterTripsRequested extends TripEvent {
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterTripsRequested({
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [status, startDate, endDate];
}
