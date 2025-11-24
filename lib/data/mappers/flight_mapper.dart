import 'package:trip_pilot/data/models/flight_model.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

/// Mapper to convert between FlightModel (data layer) and Flight (domain layer)
class FlightMapper {
  /// Convert FlightModel (DTO) to Flight (domain)
  static Flight toDomain(FlightModel model) {
    return Flight(
      id: model.id,
      airline: model.airline,
      flightNumber: model.flightNumber,
      departure: Location(
        latitude: model.departureLat,
        longitude: model.departureLng,
        city: model.departureCity,
        country: model.departureCountry,
        address: model.departureAddress,
      ),
      arrival: Location(
        latitude: model.arrivalLat,
        longitude: model.arrivalLng,
        city: model.arrivalCity,
        country: model.arrivalCountry,
        address: model.arrivalAddress,
      ),
      departureTime: model.departureTime,
      arrivalTime: model.arrivalTime,
      price: model.price,
      currency: model.currency,
      duration: model.duration,
      bookingUrl: model.bookingUrl,
    );
  }

  /// Convert Flight (domain) to FlightModel (DTO)
  static FlightModel toPresentable(Flight entity) {
    return FlightModel(
      id: entity.id,
      departureCity: entity.departure.city ?? '',
      arrivalCity: entity.arrival.city ?? '',
      departureTime: entity.departureTime,
      arrivalTime: entity.arrivalTime,
      airline: entity.airline,
      flightNumber: entity.flightNumber,
      price: entity.price,
      duration: entity.duration,
      departureCountry: entity.departure.country ?? '',
      arrivalCountry: entity.arrival.country ?? '',
      departureLat: entity.departure.latitude,
      departureLng: entity.departure.longitude,
      arrivalLat: entity.arrival.latitude,
      arrivalLng: entity.arrival.longitude,
      currency: entity.currency,
      departureAddress: entity.departure.address,
      arrivalAddress: entity.arrival.address,
      bookingUrl: entity.bookingUrl,
    );
  }

  /// Convert list of FlightModels to domain entities
  static List<Flight> toDomainList(List<FlightModel> models) {
    return models.map(toDomain).toList();
  }

  /// Convert list of domain entities to FlightModels
  static List<FlightModel> toPresentableList(List<Flight> entities) {
    return entities.map(toPresentable).toList();
  }
}
