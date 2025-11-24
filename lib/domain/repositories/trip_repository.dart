import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/domain/entities/trip.dart';

/// Abstract trip repository interface
abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getTrips();
  Future<Either<Failure, Trip>> getTripById(String tripId);
  Future<Either<Failure, Trip>> createTrip(Trip trip);
  Future<Either<Failure, Trip>> updateTrip(Trip trip);
  Future<Either<Failure, void>> deleteTrip(String tripId);
}
