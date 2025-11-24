import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

abstract class ActivitySearchService {
  /// Search activities from multiple sources
  /// 
  /// Returns list of activities matching the search criteria
  Future<Either<Failure, List<Activity>>> searchActivities({
    required String city,
    String? category,
    double? maxPrice,
  });

  /// Apply filters to existing activity results
  Future<Either<Failure, List<Activity>>> filterActivities({
    required List<Activity> activities,
    double? maxPrice,
    double? minRating,
    List<String>? categories,
  });

  /// Get activities by category
  Future<Either<Failure, List<Activity>>> getActivitiesByCategory({
    required String city,
    required String category,
  });

  /// Get top-rated activities
  Future<Either<Failure, List<Activity>>> getTopRatedActivities({
    required String city,
  });
}
