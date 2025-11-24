/// Data model for Activity
class ActivityModel {
  final String id;
  final String name;
  final double locationLat;
  final double locationLng;
  final String? locationCity;
  final String? locationCountry;
  final String? locationAddress;
  final String category;
  final double? rating;
  final double? price;
  final String currency;
  final String? description;
  final String? imageUrl;
  final String? bookingUrl;
  final int? duration;

  ActivityModel({
    required this.id,
    required this.name,
    required this.locationLat,
    required this.locationLng,
    this.locationCity,
    this.locationCountry,
    this.locationAddress,
    required this.category,
    this.rating,
    this.price,
    required this.currency,
    this.description,
    this.imageUrl,
    this.bookingUrl,
    this.duration,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      locationLat: (json['locationLat'] as num).toDouble(),
      locationLng: (json['locationLng'] as num).toDouble(),
      locationCity: json['locationCity'] as String?,
      locationCountry: json['locationCountry'] as String?,
      locationAddress: json['locationAddress'] as String?,
      category: json['category'] as String,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      bookingUrl: json['bookingUrl'] as String?,
      duration: json['duration'] as int?,
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
        'category': category,
        'rating': rating,
        'price': price,
        'currency': currency,
        'description': description,
        'imageUrl': imageUrl,
        'bookingUrl': bookingUrl,
        'duration': duration,
      };
}
