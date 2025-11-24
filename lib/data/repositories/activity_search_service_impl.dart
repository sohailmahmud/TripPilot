import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/data/datasources/remote/activity_search_service.dart'
    as remote;
import 'package:trip_pilot/data/mappers/activity_mapper.dart';
import 'package:trip_pilot/data/models/activity_model.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';
import 'package:trip_pilot/domain/repositories/activity_search_service.dart';

/// Implementation of ActivitySearchService that uses the remote service
class ActivitySearchServiceImpl implements ActivitySearchService {
  final remote.ActivitySearchService activityApiService;

  ActivitySearchServiceImpl({required this.activityApiService});

  @override
  Future<Either<Failure, List<Activity>>> searchActivities({
    required String city,
    String? category,
    double? maxPrice,
  }) async {
    try {
      final results = await activityApiService.searchActivities(
        city: city,
        category: category,
      );

      final activities = results
          .map((data) => ActivityModel.fromJson(data))
          .toList();

      // Apply price filter if provided
      if (maxPrice != null) {
        final filtered = activities
            .where((activity) => (activity.price ?? 0) <= maxPrice)
            .toList();
        return Right(ActivityMapper.toDomainList(filtered));
      }

      return Right(ActivityMapper.toDomainList(activities));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search activities: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> filterActivities({
    required List<Activity> activities,
    double? maxPrice,
    double? minRating,
    List<String>? categories,
  }) async {
    try {
      // Convert domain entities back to models for filtering
      var models = activities
          .map((activity) => ActivityMapper.toPresentable(activity))
          .toList();

      if (maxPrice != null) {
        models = models
            .where((activity) => (activity.price ?? 0) <= maxPrice)
            .toList();
      }

      if (minRating != null) {
        models = models
            .where((activity) => (activity.rating ?? 0) >= minRating)
            .toList();
      }

      if (categories != null && categories.isNotEmpty) {
        models = models
            .where((activity) =>
                categories.contains(activity.category.toLowerCase()))
            .toList();
      }

      return Right(ActivityMapper.toDomainList(models));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to filter activities: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivitiesByCategory({
    required String city,
    required String category,
  }) async {
    try {
      final results = await activityApiService.searchActivities(
        city: city,
        category: category,
      );

      final activities = results
          .map((data) => ActivityModel.fromJson(data))
          .toList();

      return Right(ActivityMapper.toDomainList(activities));
    } catch (e) {
      return Left(ServerFailure(
          message: 'Failed to get activities by category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getTopRatedActivities({
    required String city,
  }) async {
    try {
      final results = await activityApiService.searchActivities(city: city);

      final activities = results
          .map((data) => ActivityModel.fromJson(data))
          .toList();

      // Sort by rating descending
      activities.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

      return Right(ActivityMapper.toDomainList(activities));
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to get top-rated activities: $e'));
    }
  }
}
