import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_pilot/domain/repositories/trip_repository.dart';
import 'package:trip_pilot/presentation/bloc/trip/trip_event.dart';
import 'package:trip_pilot/presentation/bloc/trip/trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;

  TripBloc({required this.tripRepository}) : super(const TripInitial()) {
    on<FetchTripsRequested>(_onFetchTripsRequested);
    on<FetchTripByIdRequested>(_onFetchTripByIdRequested);
    on<CreateTripRequested>(_onCreateTripRequested);
    on<UpdateTripRequested>(_onUpdateTripRequested);
    on<DeleteTripRequested>(_onDeleteTripRequested);
    on<SearchTripsRequested>(_onSearchTripsRequested);
    on<FilterTripsRequested>(_onFilterTripsRequested);
  }

  Future<void> _onFetchTripsRequested(
    FetchTripsRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.getTrips();

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trips) {
        if (trips.isEmpty) {
          emit(const TripEmpty());
        } else {
          emit(TripsLoadSuccess(trips: trips));
        }
      },
    );
  }

  Future<void> _onFetchTripByIdRequested(
    FetchTripByIdRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.getTripById(event.tripId);

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trip) => emit(TripDetailsSuccess(trip: trip)),
    );
  }

  Future<void> _onCreateTripRequested(
    CreateTripRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.createTrip(event.trip);

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trip) => emit(TripCreateSuccess(trip: trip)),
    );
  }

  Future<void> _onUpdateTripRequested(
    UpdateTripRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.updateTrip(event.trip);

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trip) => emit(TripUpdateSuccess(trip: trip)),
    );
  }

  Future<void> _onDeleteTripRequested(
    DeleteTripRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.deleteTrip(event.tripId);

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (_) => emit(TripDeleteSuccess(tripId: event.tripId)),
    );
  }

  Future<void> _onSearchTripsRequested(
    SearchTripsRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.getTrips();

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trips) {
        final filtered = trips
            .where((trip) =>
                trip.name.toLowerCase().contains(event.query.toLowerCase()) ||
                trip.destination
                    .toLowerCase()
                    .contains(event.query.toLowerCase()))
            .toList();

        if (filtered.isEmpty) {
          emit(TripEmpty(message: 'No trips found matching "${event.query}"'));
        } else {
          emit(TripsLoadSuccess(trips: filtered));
        }
      },
    );
  }

  Future<void> _onFilterTripsRequested(
    FilterTripsRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());

    final result = await tripRepository.getTrips();

    result.fold(
      (failure) => emit(TripFailure(failure)),
      (trips) {
        var filtered = trips;

        if (event.status != null) {
          filtered = filtered.where((trip) => trip.status == event.status).toList();
        }

        if (event.startDate != null) {
          filtered = filtered
              .where((trip) => trip.startDate.isAfter(event.startDate!))
              .toList();
        }

        if (event.endDate != null) {
          filtered = filtered
              .where((trip) => trip.endDate.isBefore(event.endDate!))
              .toList();
        }

        if (filtered.isEmpty) {
          emit(const TripEmpty(message: 'No trips match the selected filters'));
        } else {
          emit(TripsLoadSuccess(trips: filtered));
        }
      },
    );
  }
}
