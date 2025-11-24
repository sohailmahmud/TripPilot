import 'package:trip_pilot/data/models/activity_model.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';

/// Mapper to convert between ActivityModel (data layer) and Activity (domain layer)
class ActivityMapper {
  /// Convert ActivityModel (DTO) to Activity (domain)
  static Activity toDomain(ActivityModel model) {
    return Activity(
      id: model.id,
      name: model.name,
      location: Location(
        latitude: model.locationLat,
        longitude: model.locationLng,
        city: model.locationCity,
        country: model.locationCountry,
        address: model.locationAddress,
      ),
      category: model.category,
      rating: model.rating,
      price: model.price,
      currency: model.currency,
      description: model.description,
      imageUrl: model.imageUrl,
      bookingUrl: model.bookingUrl,
      duration: model.duration,
    );
  }

  /// Convert Activity (domain) to ActivityModel (DTO)
  static ActivityModel toPresentable(Activity entity) {
    return ActivityModel(
      id: entity.id,
      name: entity.name,
      locationLat: entity.location.latitude,
      locationLng: entity.location.longitude,
      locationCity: entity.location.city,
      locationCountry: entity.location.country,
      locationAddress: entity.location.address,
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

  /// Convert list of ActivityModels to domain entities
  static List<Activity> toDomainList(List<ActivityModel> models) {
    return models.map(toDomain).toList();
  }

  /// Convert list of domain entities to ActivityModels
  static List<ActivityModel> toPresentableList(List<Activity> entities) {
    return entities.map(toPresentable).toList();
  }
}
