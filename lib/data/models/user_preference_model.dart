/// Data model for UserPreference
class UserPreferenceModel {
  final String userId;
  final List<String> preferredActivities;
  final List<String> preferredCuisines;
  final List<String> travelStyles;
  final int? minRating;
  final bool preferDirectFlights;
  final List<String> preferredAirlines;
  final double? maxPricePerNight;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPreferenceModel({
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

  factory UserPreferenceModel.fromJson(Map<String, dynamic> json) {
    return UserPreferenceModel(
      userId: json['userId'] as String,
      preferredActivities: List<String>.from(json['preferredActivities'] as List),
      preferredCuisines: List<String>.from(json['preferredCuisines'] as List),
      travelStyles: List<String>.from(json['travelStyles'] as List),
      minRating: json['minRating'] as int?,
      preferDirectFlights: json['preferDirectFlights'] as bool,
      preferredAirlines: List<String>.from(json['preferredAirlines'] as List),
      maxPricePerNight: json['maxPricePerNight'] != null
          ? (json['maxPricePerNight'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'preferredActivities': preferredActivities,
        'preferredCuisines': preferredCuisines,
        'travelStyles': travelStyles,
        'minRating': minRating,
        'preferDirectFlights': preferDirectFlights,
        'preferredAirlines': preferredAirlines,
        'maxPricePerNight': maxPricePerNight,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
