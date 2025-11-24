import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

abstract class FlightSearchService {
  /// Search flights from multiple sources
  /// 
  /// Returns list of flights matching the search criteria
  Future<Either<Failure, List<Flight>>> searchFlights({
    required String departureCity,
    required String arrivalCity,
    required DateTime departureDate,
    DateTime? returnDate,
    int numberOfPassengers = 1,
  });

  /// Apply filters to existing flight results
  Future<Either<Failure, List<Flight>>> filterFlights({
    required List<Flight> flights,
    double? maxPrice,
    double? minRating,
    List<String>? preferredAirlines,
    int? maxDuration,
  });

  /// Get flight price trends
  Future<Either<Failure, Map<String, dynamic>>> getPriceTrends({
    required String departureCity,
    required String arrivalCity,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get best deal flights
  Future<Either<Failure, List<Flight>>> getBestDeals({
    required String departureCity,
    required String arrivalCity,
    required DateTime departureDate,
  });
}
