import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/data/models/trip_model.dart';
import 'package:trip_pilot/data/models/flight_model.dart';
import 'package:trip_pilot/data/models/hotel_model.dart';
import 'package:trip_pilot/data/models/activity_model.dart';
import 'package:trip_pilot/data/models/user_preference_model.dart';
import 'package:trip_pilot/core/config/supabase_config.dart';

/// Supabase database service for trip management
class SupabaseTripsService {
  final SupabaseClient _client;

  SupabaseTripsService({required SupabaseClient client}) : _client = client;

  /// Get all trips for current user
  Future<Either<Failure, List<TripModel>>> getTrips() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'User not authenticated'));
      }

      final response = await _client
          .from(SupabaseConfig.tripsTable)
          .select()
          .eq('user_id', user.id);

      final trips = (response as List)
          .map((trip) => TripModel.fromJson(trip as Map<String, dynamic>))
          .toList();

      return Right(trips);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: int.tryParse(e.code ?? '500') ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch trips: ${e.toString()}'));
    }
  }

  /// Get trip by ID
  Future<Either<Failure, TripModel>> getTripById(String tripId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tripsTable)
          .select()
          .eq('id', tripId)
          .single();

      final trip = TripModel.fromJson(response);
      return Right(trip);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: int.tryParse(e.code ?? '500') ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch trip: ${e.toString()}'));
    }
  }

  /// Create new trip
  Future<Either<Failure, TripModel>> createTrip(TripModel trip) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'User not authenticated'));
      }

      final tripData = trip.toJson();
      tripData['user_id'] = user.id;

      final response = await _client
          .from(SupabaseConfig.tripsTable)
          .insert(tripData)
          .select()
          .single();

      final createdTrip = TripModel.fromJson(response);
      return Right(createdTrip);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: int.tryParse(e.code ?? '500') ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create trip: ${e.toString()}'));
    }
  }

  /// Update trip
  Future<Either<Failure, TripModel>> updateTrip(TripModel trip) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tripsTable)
          .update(trip.toJson())
          .eq('id', trip.id)
          .select()
          .single();

      final updatedTrip = TripModel.fromJson(response);
      return Right(updatedTrip);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: int.tryParse(e.code ?? '500') ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update trip: ${e.toString()}'));
    }
  }

  /// Delete trip
  Future<Either<Failure, void>> deleteTrip(String tripId) async {
    try {
      await _client.from(SupabaseConfig.tripsTable).delete().eq('id', tripId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: int.tryParse(e.code ?? '500') ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete trip: ${e.toString()}'));
    }
  }

  /// Search flights
  Future<Either<Failure, List<FlightModel>>> searchFlights({
    required String departure,
    required String arrival,
    required DateTime departureDate,
  }) async {
    try {
      final response = await _client
          .from(SupabaseConfig.flightsTable)
          .select()
          .eq('departure_city', departure)
          .eq('arrival_city', arrival)
          .gte('departure_time', departureDate.toIso8601String());

      final flights = (response as List)
          .map((flight) => FlightModel.fromJson(flight as Map<String, dynamic>))
          .toList();

      return Right(flights);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search flights: ${e.toString()}'));
    }
  }

  /// Search hotels
  Future<Either<Failure, List<HotelModel>>> searchHotels({
    required String city,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    try {
      final response = await _client
          .from(SupabaseConfig.hotelsTable)
          .select()
          .eq('location_city', city);

      final hotels = (response as List)
          .map((hotel) => HotelModel.fromJson(hotel as Map<String, dynamic>))
          .toList();

      return Right(hotels);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search hotels: ${e.toString()}'));
    }
  }

  /// Search activities
  Future<Either<Failure, List<ActivityModel>>> searchActivities({
    required String city,
    String? category,
  }) async {
    try {
      var query = _client.from(SupabaseConfig.activitiesTable).select();
      query = query.eq('location_city', city);

      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query;

      final activities = (response as List)
          .map((activity) => ActivityModel.fromJson(activity as Map<String, dynamic>))
          .toList();

      return Right(activities);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search activities: ${e.toString()}'));
    }
  }

  /// Get user preferences
  Future<Either<Failure, UserPreferenceModel>> getUserPreferences(String userId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.userPreferencesTable)
          .select()
          .eq('user_id', userId)
          .single();

      final preferences = UserPreferenceModel.fromJson(response);
      return Right(preferences);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch preferences: ${e.toString()}'));
    }
  }

  /// Save user preferences
  Future<Either<Failure, UserPreferenceModel>> saveUserPreferences(
    UserPreferenceModel preferences,
  ) async {
    try {
      final response = await _client
          .from(SupabaseConfig.userPreferencesTable)
          .upsert(preferences.toJson())
          .select()
          .single();

      final savedPreferences =
          UserPreferenceModel.fromJson(response);
      return Right(savedPreferences);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to save preferences: ${e.toString()}'));
    }
  }
}
