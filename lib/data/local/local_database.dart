import 'dart:convert';
import '../../core/utils/logger_util.dart';
import '../../objectbox.g.dart';
import 'objectbox_entities.dart';
import 'objectbox_store.dart';
import '../models/trip_model.dart';
import '../models/flight_model.dart';
import '../models/hotel_model.dart';
import '../models/activity_model.dart';

/// Local persistence layer using ObjectBox for offline-first caching.
/// High-performance NoSQL database with indexed queries and full-text search.
class LocalDatabase {
  static late final LocalDatabase _instance;
  late final Box<TripEntity> _tripBox;
  late final Box<FlightEntity> _flightBox;
  late final Box<HotelEntity> _hotelBox;
  late final Box<ActivityEntity> _activityBox;

  LocalDatabase._();

  /// Initialize the local database with ObjectBox store.
  static Future<void> initialize() async {
    await ObjectBoxStore.initialize();
    _instance = LocalDatabase._();
    _instance._tripBox = ObjectBoxStore.getTripBox();
    _instance._flightBox = ObjectBoxStore.getFlightBox();
    _instance._hotelBox = ObjectBoxStore.getHotelBox();
    _instance._activityBox = ObjectBoxStore.getActivityBox();
  }

  /// Get singleton instance of LocalDatabase.
  static LocalDatabase get instance {
    return _instance;
  }

  // ============ TRIP OPERATIONS ============

  /// Retrieves all cached trips.
  Future<List<TripModel>> getAllTrips() async {
    try {
      final entities = _tripBox.getAll();
      return _entitiesToTripModels(entities);
    } catch (e) {
      AppLogger.error('Error getting all trips', error: e);
      return [];
    }
  }

  /// Retrieves a specific trip by ID.
  Future<TripModel?> getTripById(String tripId) async {
    try {
      final entities = _tripBox
          .query(TripEntity_.id.equals(tripId))
          .build()
          .find();
      return entities.isNotEmpty ? _entityToTripModel(entities.first) : null;
    } catch (e) {
      AppLogger.error('Error getting trip by ID', error: e);
      return null;
    }
  }

  /// Retrieves all trips for a specific user.
  Future<List<TripModel>> getTripsByUserId(String userId) async {
    try {
      final entities = _tripBox
          .query(TripEntity_.userId.equals(userId))
          .build()
          .find();
      return _entitiesToTripModels(entities);
    } catch (e) {
      AppLogger.error('Error getting trips by user ID', error: e);
      return [];
    }
  }

  /// Saves or updates a single trip.
  Future<void> saveTrip(TripModel trip) async {
    try {
      final entity = _tripModelToEntity(trip);
      _tripBox.put(entity);
    } catch (e) {
      AppLogger.error('Error saving trip', error: e);
    }
  }

  /// Saves or updates multiple trips.
  Future<void> saveTrips(List<TripModel> trips) async {
    try {
      final entities = trips.map(_tripModelToEntity).toList();
      _tripBox.putMany(entities);
    } catch (e) {
      AppLogger.error('Error saving trips', error: e);
    }
  }

  /// Deletes a trip by ID.
  Future<void> deleteTrip(String tripId) async {
    try {
      final entities = _tripBox
          .query(TripEntity_.id.equals(tripId))
          .build()
          .find();
      if (entities.isNotEmpty) {
        _tripBox.remove(entities.first.obId);
      }
    } catch (e) {
      AppLogger.error('Error deleting trip', error: e);
    }
  }

  /// Deletes all trips for a specific user.
  Future<void> deleteUserTrips(String userId) async {
    try {
      final entities = _tripBox
          .query(TripEntity_.userId.equals(userId))
          .build()
          .find();
      for (var entity in entities) {
        _tripBox.remove(entity.obId);
      }
    } catch (e) {
      AppLogger.error('Error deleting user trips', error: e);
    }
  }

  /// Clears all cached trips.
  Future<void> clearAllTrips() async {
    try {
      _tripBox.removeAll();
    } catch (e) {
      AppLogger.error('Error clearing all trips', error: e);
    }
  }

  // ============ FLIGHT OPERATIONS ============

  /// Retrieves all cached flights.
  Future<List<FlightModel>> getAllFlights() async {
    try {
      final entities = _flightBox.getAll();
      return _entitiesToFlightModels(entities);
    } catch (e) {
      AppLogger.error('Error getting all flights', error: e);
      return [];
    }
  }

  /// Saves or updates multiple flights.
  Future<void> saveFlights(List<FlightModel> flights) async {
    try {
      final entities = flights.map(_flightModelToEntity).toList();
      _flightBox.putMany(entities);
    } catch (e) {
      AppLogger.error('Error saving flights', error: e);
    }
  }

  /// Retrieves flights filtered by destination.
  Future<List<FlightModel>> getFlightsByDestination(String destination) async {
    try {
      final entities = _flightBox
          .query(FlightEntity_.arrivalCity.contains(destination, caseSensitive: false))
          .build()
          .find();
      return _entitiesToFlightModels(entities);
    } catch (e) {
      AppLogger.error('Error getting flights by destination', error: e);
      return [];
    }
  }

  /// Clears all cached flights.
  Future<void> clearFlightCache() async {
    try {
      _flightBox.removeAll();
    } catch (e) {
      AppLogger.error('Error clearing flight cache', error: e);
    }
  }

  // ============ HOTEL OPERATIONS ============

  /// Retrieves all cached hotels.
  Future<List<HotelModel>> getAllHotels() async {
    try {
      final entities = _hotelBox.getAll();
      return _entitiesToHotelModels(entities);
    } catch (e) {
      AppLogger.error('Error getting all hotels', error: e);
      return [];
    }
  }

  /// Saves or updates multiple hotels.
  Future<void> saveHotels(List<HotelModel> hotels) async {
    try {
      final entities = hotels.map(_hotelModelToEntity).toList();
      _hotelBox.putMany(entities);
    } catch (e) {
      AppLogger.error('Error saving hotels', error: e);
    }
  }

  /// Retrieves hotels filtered by location city.
  Future<List<HotelModel>> getHotelsByLocation(String city) async {
    try {
      final entities = _hotelBox
          .query(HotelEntity_.locationCity.contains(city, caseSensitive: false))
          .build()
          .find();
      return _entitiesToHotelModels(entities);
    } catch (e) {
      AppLogger.error('Error getting hotels by location', error: e);
      return [];
    }
  }

  /// Retrieves hotels within a price range.
  Future<List<HotelModel>> getHotelsInPriceRange(
      double minPrice, double maxPrice) async {
    try {
      final entities = _hotelBox
          .query(HotelEntity_.pricePerNight.between(minPrice, maxPrice))
          .build()
          .find();
      return _entitiesToHotelModels(entities);
    } catch (e) {
      AppLogger.error('Error getting hotels in price range', error: e);
      return [];
    }
  }

  /// Clears all cached hotels.
  Future<void> clearHotelCache() async {
    try {
      _hotelBox.removeAll();
    } catch (e) {
      AppLogger.error('Error clearing hotel cache', error: e);
    }
  }

  // ============ ACTIVITY OPERATIONS ============

  /// Retrieves all cached activities.
  Future<List<ActivityModel>> getAllActivities() async {
    try {
      final entities = _activityBox.getAll();
      return _entitiesToActivityModels(entities);
    } catch (e) {
      AppLogger.error('Error getting all activities', error: e);
      return [];
    }
  }

  /// Saves or updates multiple activities.
  Future<void> saveActivities(List<ActivityModel> activities) async {
    try {
      final entities = activities.map(_activityModelToEntity).toList();
      _activityBox.putMany(entities);
    } catch (e) {
      AppLogger.error('Error saving activities', error: e);
    }
  }

  /// Retrieves activities filtered by category.
  Future<List<ActivityModel>> getActivitiesByCategory(String category) async {
    try {
      final entities = _activityBox
          .query(ActivityEntity_.category.contains(category, caseSensitive: false))
          .build()
          .find();
      return _entitiesToActivityModels(entities);
    } catch (e) {
      AppLogger.error('Error getting activities by category', error: e);
      return [];
    }
  }

  /// Retrieves activities with a minimum rating.
  Future<List<ActivityModel>> getActivitiesByRating(double minRating) async {
    try {
      final entities = _activityBox
          .query(ActivityEntity_.rating.greaterOrEqual(minRating))
          .build()
          .find();
      return _entitiesToActivityModels(entities);
    } catch (e) {
      AppLogger.error('Error getting activities by rating', error: e);
      return [];
    }
  }

  /// Clears all cached activities.
  Future<void> clearActivityCache() async {
    try {
      _activityBox.removeAll();
    } catch (e) {
      AppLogger.error('Error clearing activity cache', error: e);
    }
  }

  // ============ GENERAL OPERATIONS ============

  /// Clears all cached data.
  Future<void> clearAllCaches() async {
    try {
      _tripBox.removeAll();
      _flightBox.removeAll();
      _hotelBox.removeAll();
      _activityBox.removeAll();
    } catch (e) {
      AppLogger.error('Error clearing all caches', error: e);
    }
  }

  /// Gets statistics about cached data.
  Future<Map<String, int>> getDatabaseStats() async {
    try {
      return {
        'trips': _tripBox.count(),
        'flights': _flightBox.count(),
        'hotels': _hotelBox.count(),
        'activities': _activityBox.count(),
      };
    } catch (e) {
      AppLogger.error('Error getting database stats', error: e);
      return {'trips': 0, 'flights': 0, 'hotels': 0, 'activities': 0};
    }
  }

  /// Closes database connection.
  void close() {
    try {
      ObjectBoxStore.close();
    } catch (e) {
      AppLogger.error('Error closing database', error: e);
    }
  }

  // ============ CONVERSION HELPERS ============

  TripEntity _tripModelToEntity(TripModel model) {
    final entity = TripEntity();
    entity.id = model.id;
    entity.userId = model.userId;
    entity.name = model.name;
    entity.description = model.description;
    entity.destination = model.destination;
    entity.startDate = model.startDate;
    entity.endDate = model.endDate;
    entity.destinationsJson = jsonEncode(model.destinations);
    entity.outboundFlightJson = model.outboundFlightJson;
    entity.returnFlightJson = model.returnFlightJson;
    entity.hotelsJson = model.hotelsJson;
    entity.activitiesJson = model.activitiesJson;
    entity.itineraryJson = jsonEncode(model.itinerary.map((i) => i.toJson()).toList());
    entity.budgetJson = model.budgetJson;
    entity.status = model.status;
    entity.numberOfPeople = model.numberOfPeople;
    entity.coverImageUrl = model.coverImageUrl;
    entity.tagsJson = jsonEncode(model.tags);
    entity.createdAt = model.createdAt;
    entity.updatedAt = model.updatedAt;
    return entity;
  }

  TripModel _entityToTripModel(TripEntity entity) {
    return TripModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      destination: entity.destination,
      destinations: List<String>.from(jsonDecode(entity.destinationsJson) ?? []),
      outboundFlightJson: entity.outboundFlightJson,
      returnFlightJson: entity.returnFlightJson,
      hotelsJson: entity.hotelsJson,
      activitiesJson: entity.activitiesJson,
      itinerary: _decodeItinerary(entity.itineraryJson),
      budgetJson: entity.budgetJson,
      status: entity.status,
      numberOfPeople: entity.numberOfPeople,
      coverImageUrl: entity.coverImageUrl,
      tags: List<String>.from(jsonDecode(entity.tagsJson) ?? []),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  List<TripModel> _entitiesToTripModels(List<TripEntity> entities) {
    return entities.map(_entityToTripModel).toList();
  }

  FlightEntity _flightModelToEntity(FlightModel model) {
    final entity = FlightEntity();
    entity.id = model.id;
    entity.departureCity = model.departureCity;
    entity.arrivalCity = model.arrivalCity;
    entity.departureTime = model.departureTime;
    entity.arrivalTime = model.arrivalTime;
    entity.airline = model.airline;
    entity.flightNumber = model.flightNumber;
    entity.price = model.price;
    entity.duration = model.duration;
    entity.departureCountry = model.departureCountry;
    entity.arrivalCountry = model.arrivalCountry;
    entity.departureLat = model.departureLat;
    entity.departureLng = model.departureLng;
    entity.arrivalLat = model.arrivalLat;
    entity.arrivalLng = model.arrivalLng;
    entity.currency = model.currency;
    entity.departureAddress = model.departureAddress;
    entity.arrivalAddress = model.arrivalAddress;
    entity.bookingUrl = model.bookingUrl;
    return entity;
  }

  FlightModel _entityToFlightModel(FlightEntity entity) {
    return FlightModel(
      id: entity.id,
      departureCity: entity.departureCity,
      arrivalCity: entity.arrivalCity,
      departureTime: entity.departureTime,
      arrivalTime: entity.arrivalTime,
      airline: entity.airline,
      flightNumber: entity.flightNumber ?? '',
      price: entity.price,
      duration: entity.duration,
      departureCountry: entity.departureCountry ?? '',
      arrivalCountry: entity.arrivalCountry ?? '',
      departureLat: entity.departureLat ?? 0.0,
      departureLng: entity.departureLng ?? 0.0,
      arrivalLat: entity.arrivalLat ?? 0.0,
      arrivalLng: entity.arrivalLng ?? 0.0,
      currency: entity.currency ?? '',
      departureAddress: entity.departureAddress,
      arrivalAddress: entity.arrivalAddress,
      bookingUrl: entity.bookingUrl,
    );
  }

  List<FlightModel> _entitiesToFlightModels(List<FlightEntity> entities) {
    return entities.map(_entityToFlightModel).toList();
  }

  HotelEntity _hotelModelToEntity(HotelModel model) {
    final entity = HotelEntity();
    entity.id = model.id;
    entity.name = model.name;
    entity.locationLat = model.locationLat;
    entity.locationLng = model.locationLng;
    entity.locationCity = model.locationCity;
    entity.locationCountry = model.locationCountry;
    entity.locationAddress = model.locationAddress;
    entity.pricePerNight = model.pricePerNight;
    entity.rating = model.rating;
    entity.reviewCount = model.reviewCount;
    entity.currency = model.currency;
    entity.amenitiesJson = jsonEncode(model.amenities);
    entity.imageUrl = model.imageUrl;
    entity.description = model.description;
    entity.bookingUrl = model.bookingUrl;
    entity.distance = model.distance;
    return entity;
  }

  HotelModel _entityToHotelModel(HotelEntity entity) {
    return HotelModel(
      id: entity.id,
      name: entity.name,
      locationLat: entity.locationLat,
      locationLng: entity.locationLng,
      locationCity: entity.locationCity,
      locationCountry: entity.locationCountry,
      locationAddress: entity.locationAddress,
      pricePerNight: entity.pricePerNight,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      currency: entity.currency,
      amenities: List<String>.from(jsonDecode(entity.amenitiesJson) ?? []),
      imageUrl: entity.imageUrl,
      description: entity.description,
      bookingUrl: entity.bookingUrl,
      distance: entity.distance,
    );
  }

  List<HotelModel> _entitiesToHotelModels(List<HotelEntity> entities) {
    return entities.map(_entityToHotelModel).toList();
  }

  ActivityEntity _activityModelToEntity(ActivityModel model) {
    final entity = ActivityEntity();
    entity.id = model.id;
    entity.name = model.name;
    entity.locationLat = model.locationLat;
    entity.locationLng = model.locationLng;
    entity.locationCity = model.locationCity;
    entity.locationCountry = model.locationCountry;
    entity.locationAddress = model.locationAddress;
    entity.category = model.category;
    entity.rating = model.rating;
    entity.price = model.price;
    entity.currency = model.currency;
    entity.description = model.description;
    entity.imageUrl = model.imageUrl;
    entity.bookingUrl = model.bookingUrl;
    entity.duration = model.duration;
    return entity;
  }

  ActivityModel _entityToActivityModel(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      name: entity.name,
      locationLat: entity.locationLat,
      locationLng: entity.locationLng,
      locationCity: entity.locationCity,
      locationCountry: entity.locationCountry,
      locationAddress: entity.locationAddress,
      category: entity.category,
      rating: entity.rating,
      price: entity.price,
      currency: entity.currency,
      description: entity.description,
      imageUrl: entity.imageUrl,
      bookingUrl: entity.bookingUrl,
      duration: entity.duration,
    );
  }

  List<ActivityModel> _entitiesToActivityModels(List<ActivityEntity> entities) {
    return entities.map(_entityToActivityModel).toList();
  }

  // Helper to decode itinerary from JSON
  List<ItineraryItemModel> _decodeItinerary(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => ItineraryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error('Error decoding itinerary', error: e);
      return [];
    }
  }
}
