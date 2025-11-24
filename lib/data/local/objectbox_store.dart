import '../../objectbox.g.dart';
import 'objectbox_entities.dart';

/// Singleton for managing ObjectBox store initialization and access.
class ObjectBoxStore {
  static late final Store _store;

  /// Initialize ObjectBox store once at app startup.
  static Future<void> initialize() async {
    _store = await openStore();
  }

  /// Get Trip box for CRUD operations.
  static Box<TripEntity> getTripBox() => _store.box<TripEntity>();

  /// Get Flight box for CRUD operations.
  static Box<FlightEntity> getFlightBox() => _store.box<FlightEntity>();

  /// Get Hotel box for CRUD operations.
  static Box<HotelEntity> getHotelBox() => _store.box<HotelEntity>();

  /// Get Activity box for CRUD operations.
  static Box<ActivityEntity> getActivityBox() => _store.box<ActivityEntity>();

  /// Close the ObjectBox store.
  static void close() {
    _store.close();
  }
}
