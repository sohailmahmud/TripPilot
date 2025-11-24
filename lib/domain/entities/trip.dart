import 'package:equatable/equatable.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';
import 'package:trip_pilot/domain/entities/budget.dart';

/// Represents an itinerary item for a specific day
class ItineraryItem extends Equatable {
  final String id;
  final int dayNumber;
  final String title;
  final String? description;
  final DateTime scheduledTime;
  final String? location;
  final String? category; // 'flight', 'hotel', 'activity', 'meal', 'transport'
  final String? notes;

  const ItineraryItem({
    required this.id,
    required this.dayNumber,
    required this.title,
    this.description,
    required this.scheduledTime,
    this.location,
    this.category,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        dayNumber,
        title,
        description,
        scheduledTime,
        location,
        category,
        notes,
      ];
}

/// Represents a complete trip
class Trip extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String destination; // main destination city/country
  final List<String> destinations; // multiple destinations
  final Flight? outboundFlight;
  final Flight? returnFlight;
  final List<Hotel>? hotels;
  final List<Activity>? activities;
  final List<ItineraryItem> itinerary;
  final Budget? budget;
  final String status; // 'draft', 'planning', 'booked', 'completed'
  final int numberOfPeople;
  final String? coverImageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Trip({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.destinations,
    this.outboundFlight,
    this.returnFlight,
    this.hotels,
    this.activities,
    required this.itinerary,
    this.budget,
    required this.status,
    required this.numberOfPeople,
    this.coverImageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  int get numberOfDays => endDate.difference(startDate).inDays + 1;

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        startDate,
        endDate,
        destination,
        destinations,
        outboundFlight,
        returnFlight,
        hotels,
        activities,
        itinerary,
        budget,
        status,
        numberOfPeople,
        coverImageUrl,
        tags,
        createdAt,
        updatedAt,
      ];
}
