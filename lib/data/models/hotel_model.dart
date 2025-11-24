/// Data model for Hotel
class HotelModel {
  final String id;
  final String name;
  final double locationLat;
  final double locationLng;
  final String? locationCity;
  final String? locationCountry;
  final String? locationAddress;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String currency;
  final List<String> amenities;
  final String? imageUrl;
  final String? description;
  final String? bookingUrl;
  final double distance; // Distance in km from city center

  HotelModel({
    required this.id,
    required this.name,
    required this.locationLat,
    required this.locationLng,
    this.locationCity,
    this.locationCountry,
    this.locationAddress,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.currency,
    required this.amenities,
    this.imageUrl,
    this.description,
    this.bookingUrl,
    this.distance = 0.0,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      locationLat: (json['locationLat'] as num).toDouble(),
      locationLng: (json['locationLng'] as num).toDouble(),
      locationCity: json['locationCity'] as String?,
      locationCountry: json['locationCountry'] as String?,
      locationAddress: json['locationAddress'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      currency: json['currency'] as String,
      amenities: List<String>.from(json['amenities'] as List),
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      bookingUrl: json['bookingUrl'] as String?,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'locationLat': locationLat,
        'locationLng': locationLng,
        'locationCity': locationCity,
        'locationCountry': locationCountry,
        'locationAddress': locationAddress,
        'rating': rating,
        'reviewCount': reviewCount,
        'pricePerNight': pricePerNight,
        'currency': currency,
        'amenities': amenities,
        'imageUrl': imageUrl,
        'description': description,
        'bookingUrl': bookingUrl,
        'distance': distance,
      };
}
