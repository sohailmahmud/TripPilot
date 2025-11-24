/// Data model for Flight
class FlightModel {
  final String id;
  final String airline;
  final String flightNumber;
  final String departureCity;
  final String departureCountry;
  final double departureLat;
  final double departureLng;
  final String? departureAddress;
  final String arrivalCity;
  final String arrivalCountry;
  final double arrivalLat;
  final double arrivalLng;
  final String? arrivalAddress;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String currency;
  final int duration; // in minutes
  final String? bookingUrl;

  FlightModel({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.departureCity,
    required this.departureCountry,
    required this.departureLat,
    required this.departureLng,
    this.departureAddress,
    required this.arrivalCity,
    required this.arrivalCountry,
    required this.arrivalLat,
    required this.arrivalLng,
    this.arrivalAddress,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.currency,
    required this.duration,
    this.bookingUrl,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] as String,
      airline: json['airline'] as String,
      flightNumber: json['flightNumber'] as String,
      departureCity: json['departureCity'] as String,
      departureCountry: json['departureCountry'] as String,
      departureLat: (json['departureLat'] as num).toDouble(),
      departureLng: (json['departureLng'] as num).toDouble(),
      departureAddress: json['departureAddress'] as String?,
      arrivalCity: json['arrivalCity'] as String,
      arrivalCountry: json['arrivalCountry'] as String,
      arrivalLat: (json['arrivalLat'] as num).toDouble(),
      arrivalLng: (json['arrivalLng'] as num).toDouble(),
      arrivalAddress: json['arrivalAddress'] as String?,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      duration: json['duration'] as int,
      bookingUrl: json['bookingUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'airline': airline,
        'flightNumber': flightNumber,
        'departureCity': departureCity,
        'departureCountry': departureCountry,
        'departureLat': departureLat,
        'departureLng': departureLng,
        'departureAddress': departureAddress,
        'arrivalCity': arrivalCity,
        'arrivalCountry': arrivalCountry,
        'arrivalLat': arrivalLat,
        'arrivalLng': arrivalLng,
        'arrivalAddress': arrivalAddress,
        'departureTime': departureTime.toIso8601String(),
        'arrivalTime': arrivalTime.toIso8601String(),
        'price': price,
        'currency': currency,
        'duration': duration,
        'bookingUrl': bookingUrl,
      };
}
