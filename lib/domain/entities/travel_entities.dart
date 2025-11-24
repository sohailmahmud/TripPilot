import 'package:equatable/equatable.dart';

/// Represents a location with coordinates and address
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;

  const Location({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [latitude, longitude, address, city, country];
}

/// Represents a flight
class Flight extends Equatable {
  final String id;
  final String airline;
  final String flightNumber;
  final Location departure;
  final Location arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String currency;
  final int duration; // in minutes
  final String? bookingUrl;

  const Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.currency,
    required this.duration,
    this.bookingUrl,
  });

  @override
  List<Object?> get props => [
        id,
        airline,
        flightNumber,
        departure,
        arrival,
        departureTime,
        arrivalTime,
        price,
        currency,
        duration,
        bookingUrl,
      ];
}

/// Represents a hotel
class Hotel extends Equatable {
  final String id;
  final String name;
  final Location location;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String currency;
  final List<String> amenities;
  final String? imageUrl;
  final String? description;
  final String? bookingUrl;
  final double distance; // distance from city center in km

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
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

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        rating,
        reviewCount,
        pricePerNight,
        currency,
        amenities,
        imageUrl,
        description,
        bookingUrl,
        distance,
      ];
}

/// Represents an activity/attraction
class Activity extends Equatable {
  final String id;
  final String name;
  final Location location;
  final String category; // e.g., 'sightseeing', 'dining', 'adventure'
  final double? rating;
  final double? price;
  final String currency;
  final String? description;
  final String? imageUrl;
  final String? bookingUrl;
  final int? duration; // in minutes

  const Activity({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    this.rating,
    this.price,
    required this.currency,
    this.description,
    this.imageUrl,
    this.bookingUrl,
    this.duration,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        category,
        rating,
        price,
        currency,
        description,
        imageUrl,
        bookingUrl,
        duration,
      ];
}
