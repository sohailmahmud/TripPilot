import 'package:equatable/equatable.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/domain/entities/trip.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {
  const TripInitial();
}

class TripLoading extends TripState {
  const TripLoading();
}

class TripsLoadSuccess extends TripState {
  final List<Trip> trips;

  const TripsLoadSuccess({required this.trips});

  @override
  List<Object?> get props => [trips];
}

class TripDetailsSuccess extends TripState {
  final Trip trip;

  const TripDetailsSuccess({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class TripCreateSuccess extends TripState {
  final Trip trip;
  final String message;

  const TripCreateSuccess({
    required this.trip,
    this.message = 'Trip created successfully',
  });

  @override
  List<Object?> get props => [trip, message];
}

class TripUpdateSuccess extends TripState {
  final Trip trip;
  final String message;

  const TripUpdateSuccess({
    required this.trip,
    this.message = 'Trip updated successfully',
  });

  @override
  List<Object?> get props => [trip, message];
}

class TripDeleteSuccess extends TripState {
  final String tripId;
  final String message;

  const TripDeleteSuccess({
    required this.tripId,
    this.message = 'Trip deleted successfully',
  });

  @override
  List<Object?> get props => [tripId, message];
}

class TripFailure extends TripState {
  final Failure failure;

  const TripFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class TripEmpty extends TripState {
  final String message;

  const TripEmpty({this.message = 'No trips found'});

  @override
  List<Object?> get props => [message];
}
