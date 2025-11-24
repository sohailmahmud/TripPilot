import 'package:trip_pilot/data/models/hotel_model.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

/// Mapper to convert between HotelModel (data layer) and Hotel (domain layer)
class HotelMapper {
  /// Convert HotelModel (DTO) to Hotel (domain)
  static Hotel toDomain(HotelModel model) {
    return Hotel(
      id: model.id,
      name: model.name,
      location: Location(
        latitude: model.locationLat,
        longitude: model.locationLng,
        city: model.locationCity,
        country: model.locationCountry,
        address: model.locationAddress,
      ),
      rating: model.rating,
      reviewCount: model.reviewCount,
      pricePerNight: model.pricePerNight,
      currency: model.currency,
      amenities: model.amenities,
      imageUrl: model.imageUrl,
      description: model.description,
      bookingUrl: model.bookingUrl,
      distance: model.distance,
    );
  }

  /// Convert Hotel (domain) to HotelModel (DTO)
  static HotelModel toPresentable(Hotel entity) {
    return HotelModel(
      id: entity.id,
      name: entity.name,
      locationLat: entity.location.latitude,
      locationLng: entity.location.longitude,
      locationCity: entity.location.city,
      locationCountry: entity.location.country,
      locationAddress: entity.location.address,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      pricePerNight: entity.pricePerNight,
      currency: entity.currency,
      amenities: entity.amenities,
      imageUrl: entity.imageUrl,
      description: entity.description,
      bookingUrl: entity.bookingUrl,
      distance: entity.distance,
    );
  }

  /// Convert list of HotelModels to domain entities
  static List<Hotel> toDomainList(List<HotelModel> models) {
    return models.map(toDomain).toList();
  }

  /// Convert list of domain entities to HotelModels
  static List<HotelModel> toPresentableList(List<Hotel> entities) {
    return entities.map(toPresentable).toList();
  }
}
