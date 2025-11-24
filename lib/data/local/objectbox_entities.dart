import 'package:objectbox/objectbox.dart';

/// ObjectBox entity for Trip
@Entity()
class TripEntity {
  @Id() int obId = 0;
  @Index() String id = '';
  @Index() String userId = '';
  String name = '';
  String? description;
  String destination = '';
  @Property(type: PropertyType.date) DateTime startDate = DateTime.now();
  @Property(type: PropertyType.date) DateTime endDate = DateTime.now();
  String destinationsJson = '[]';
  String? outboundFlightJson;
  String? returnFlightJson;
  String? hotelsJson;
  String? activitiesJson;
  String itineraryJson = '[]';
  String? budgetJson;
  String status = 'planned';
  int numberOfPeople = 1;
  String? coverImageUrl;
  String tagsJson = '[]';
  @Property(type: PropertyType.date) DateTime createdAt = DateTime.now();
  @Property(type: PropertyType.date) DateTime updatedAt = DateTime.now();
}

/// ObjectBox entity for Flight
@Entity()
class FlightEntity {
  @Id() int obId = 0;
  @Index() String id = '';
  String departureCity = '';
  String arrivalCity = '';
  @Property(type: PropertyType.date) DateTime departureTime = DateTime.now();
  @Property(type: PropertyType.date) DateTime arrivalTime = DateTime.now();
  String airline = '';
  String? flightNumber;
  double price = 0.0;
  int duration = 0;
  String? departureCountry;
  String? arrivalCountry;
  double? departureLat;
  double? departureLng;
  double? arrivalLat;
  double? arrivalLng;
  String? currency;
  String? departureAddress;
  String? arrivalAddress;
  String? bookingUrl;
}

/// ObjectBox entity for Hotel
@Entity()
class HotelEntity {
  @Id() int obId = 0;
  @Index() String id = '';
  String name = '';
  double locationLat = 0.0;
  double locationLng = 0.0;
  String? locationCity;
  String? locationCountry;
  String? locationAddress;
  double rating = 0.0;
  int reviewCount = 0;
  double pricePerNight = 0.0;
  String currency = '';
  String amenitiesJson = '[]';
  String? imageUrl;
  String? description;
  String? bookingUrl;
  double distance = 0.0;
}

/// ObjectBox entity for Activity
@Entity()
class ActivityEntity {
  @Id() int obId = 0;
  @Index() String id = '';
  String name = '';
  double locationLat = 0.0;
  double locationLng = 0.0;
  String? locationCity;
  String? locationCountry;
  String? locationAddress;
  @Index() String category = '';
  double? rating;
  double? price;
  String currency = '';
  String? description;
  String? imageUrl;
  String? bookingUrl;
  int? duration;
}
