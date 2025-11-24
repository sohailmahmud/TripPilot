import 'package:equatable/equatable.dart';

/// Represents user preferences for trip recommendations
class UserPreference extends Equatable {
  final String userId;
  final List<String> preferredActivities; // e.g., ['hiking', 'museums', 'dining']
  final List<String> preferredCuisines;
  final List<String> travelStyles; // e.g., ['luxury', 'budget', 'adventure']
  final int? minRating; // minimum rating preference for accommodations
  final bool preferDirectFlights;
  final List<String> preferredAirlines;
  final double? maxPricePerNight; // maximum hotel price preference
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserPreference({
    required this.userId,
    required this.preferredActivities,
    required this.preferredCuisines,
    required this.travelStyles,
    this.minRating,
    required this.preferDirectFlights,
    required this.preferredAirlines,
    this.maxPricePerNight,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        userId,
        preferredActivities,
        preferredCuisines,
        travelStyles,
        minRating,
        preferDirectFlights,
        preferredAirlines,
        maxPricePerNight,
        createdAt,
        updatedAt,
      ];
}
