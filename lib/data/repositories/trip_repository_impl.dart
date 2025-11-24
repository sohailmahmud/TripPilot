import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/data/datasources/remote/supabase_trips_service.dart';
import 'package:trip_pilot/data/models/trip_model.dart';
import 'package:trip_pilot/domain/repositories/trip_repository.dart';
import 'package:trip_pilot/domain/entities/trip.dart';

/// Implementation of trip repository
class TripRepositoryImpl implements TripRepository {
  final SupabaseTripsService _supabaseService;

  TripRepositoryImpl({required SupabaseTripsService supabaseService})
      : _supabaseService = supabaseService;

  /// Simple conversion from TripModel to Trip
  /// Note: This is a simplified conversion - full mapping would be in TripMapper
  Trip _modelToEntity(TripModel model) {
    return Trip(
      id: model.id,
      userId: model.userId,
      name: model.name,
      description: model.description,
      startDate: model.startDate,
      endDate: model.endDate,
      destination: model.destination,
      destinations: model.destinations,
      itinerary: [], // TODO: Map from ItineraryItemModel
      status: model.status,
      numberOfPeople: model.numberOfPeople,
      coverImageUrl: model.coverImageUrl,
      tags: model.tags,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Simple conversion from Trip to TripModel
  /// Note: This is a simplified conversion - full mapping would be in TripMapper
  TripModel _entityToModel(Trip entity) {
    return TripModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      destination: entity.destination,
      destinations: entity.destinations,
      itinerary: [], // TODO: Map from ItineraryItem
      status: entity.status,
      numberOfPeople: entity.numberOfPeople,
      coverImageUrl: entity.coverImageUrl,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<Either<Failure, List<Trip>>> getTrips() async {
    final result = await _supabaseService.getTrips();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map(_modelToEntity).toList()),
    );
  }

  @override
  Future<Either<Failure, Trip>> getTripById(String tripId) async {
    final result = await _supabaseService.getTripById(tripId);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(_modelToEntity(model)),
    );
  }

  @override
  Future<Either<Failure, Trip>> createTrip(Trip trip) async {
    final model = _entityToModel(trip);
    final result = await _supabaseService.createTrip(model);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(_modelToEntity(model)),
    );
  }

  @override
  Future<Either<Failure, Trip>> updateTrip(Trip trip) async {
    final model = _entityToModel(trip);
    final result = await _supabaseService.updateTrip(model);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(_modelToEntity(model)),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTrip(String tripId) async {
    return await _supabaseService.deleteTrip(tripId);
  }
}
