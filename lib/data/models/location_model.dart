/// Data model for Location
class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'country': country,
      };
}
