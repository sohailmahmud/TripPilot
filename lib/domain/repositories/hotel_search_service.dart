import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

abstract class HotelSearchService {
  /// Search hotels from multiple sources
  /// 
  /// Returns list of hotels matching the search criteria
  Future<Either<Failure, List<Hotel>>> searchHotels({
    required String city,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    int numberOfGuests = 1,
  });

  /// Apply filters to existing hotel results
  Future<Either<Failure, List<Hotel>>> filterHotels({
    required List<Hotel> hotels,
    double? maxPrice,
    double? minRating,
    List<String>? amenities,
  });

  /// Get available hotels with pricing info
  Future<Either<Failure, List<Hotel>>> getAvailableHotels({
    required String city,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  });

  /// Get best value hotels based on rating and price
  Future<Either<Failure, List<Hotel>>> getBestValueHotels({
    required String city,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  });
}
