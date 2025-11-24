import 'package:trip_pilot/core/errors/failures.dart';
import 'package:trip_pilot/core/utils/either.dart';
import 'package:trip_pilot/core/utils/logger_util.dart';
import 'package:trip_pilot/data/datasources/remote/amadeus_hotel_service.dart';
import 'package:trip_pilot/data/mappers/hotel_mapper.dart';
import 'package:trip_pilot/data/models/hotel_model.dart';
import 'package:trip_pilot/domain/entities/travel_entities.dart';
import 'package:trip_pilot/domain/repositories/hotel_search_service.dart';

class HotelSearchServiceImpl implements HotelSearchService {
  final AmadeusHotelService hotelApiService;

  HotelSearchServiceImpl({required this.hotelApiService});

  @override
  Future<Either<Failure, List<Hotel>>> searchHotels({
    required String city,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    int numberOfGuests = 1,
  }) async {
    try {
      final nights = checkOutDate.difference(checkInDate).inDays;

      // Validate dates early - if check-in is in the past, use mock data
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final checkInDate2 = DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
      
      if (checkInDate2.isBefore(today)) {
        AppLogger.info('Check-in date is in the past, using mock data');
        final fallbackHotels = _generateMockHotels(city, nights);
        return Right(HotelMapper.toDomainList(fallbackHotels));
      }

      // First, try to get city code from Amadeus
      final cityCode = await _getCityCode(city);
      if (cityCode != null) {
        AppLogger.info('Attempting Amadeus hotel search for city code: $cityCode');
        final amadeusResult = await hotelApiService.searchHotels(
          cityCode: cityCode,
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
          adults: numberOfGuests,
        );

        if (amadeusResult != null && amadeusResult['data'] != null) {
          final hotels = _parseAmadeusHotels(amadeusResult['data'] as List, city, nights);
          if (hotels.isNotEmpty) {
            AppLogger.info('Successfully retrieved ${hotels.length} real hotels from Amadeus');
            return Right(HotelMapper.toDomainList(hotels));
          }
        }
        AppLogger.info('Amadeus hotel search returned no results, falling back to mock data');
      } else {
        AppLogger.warning('Could not resolve city code for "$city", using mock data');
      }

      // Fallback to mock data
      AppLogger.info('Generating mock hotels for $city');
      final fallbackHotels = _generateMockHotels(city, nights);
      return Right(HotelMapper.toDomainList(fallbackHotels));
    } catch (e) {
      // Fallback to mock data on error
      try {
        final nights = checkOutDate.difference(checkInDate).inDays;
        final fallbackHotels = _generateMockHotels(city, nights);
        return Right(HotelMapper.toDomainList(fallbackHotels));
      } catch (mockError) {
        return Left(
          NetworkFailure(
            message: 'Hotel search failed: ${e.toString()}',
          ),
        );
      }
    }
  }

  /// Get city code from city name
  Future<String?> _getCityCode(String cityName) async {
    final normalized = cityName.trim().toLowerCase();
    AppLogger.info('_getCityCode: Looking up city code for "$cityName" (normalized: "$normalized")');
    
    final staticMapping = _getStaticCityCode(normalized);
    if (staticMapping != null) {
      AppLogger.info('_getCityCode: Found static mapping for "$normalized" → "$staticMapping"');
      return staticMapping;
    }
    
    AppLogger.info('_getCityCode: No static mapping found for "$normalized", trying Amadeus API as fallback');
    
    // Try Amadeus city search for cities not in static mapping
    // Note: This is a fallback and may not work for all cities
    try {
      final cities = await hotelApiService.getCitySearch(cityName);
      if (cities.isNotEmpty) {
        final iataCode = cities.first['iataCode']?.toString();
        if (iataCode != null && iataCode.length == 3) {
          AppLogger.info('_getCityCode: Found IATA code from API for "$cityName": "$iataCode"');
          return iataCode;
        }
      }
      AppLogger.warning('_getCityCode: Amadeus API returned no results for "$cityName"');
    } catch (e) {
      AppLogger.warning('_getCityCode: Amadeus API lookup failed for "$cityName": $e');
    }
    
    AppLogger.warning('_getCityCode: Could not find city code for "$cityName", will use mock data');
    return null;
  }

  /// Static city to city code mapping
  String? _getStaticCityCode(String cityName) {
    final cityToCityCode = {
      // North America
      'new york': 'NYC',
      'new york city': 'NYC',
      'los angeles': 'LAX',
      'chicago': 'ORD',
      'toronto': 'YYZ',
      'vancouver': 'YVR',
      'mexico city': 'MEX',
      'miami': 'MIA',
      'san francisco': 'SFO',
      'seattle': 'SEA',
      'boston': 'BOS',
      'atlanta': 'ATL',
      'denver': 'DEN',
      'las vegas': 'LAS',
      'orlando': 'MCO',
      'dallas': 'DFW',
      'houston': 'IAH',
      'phoenix': 'PHX',
      'philadelphia': 'PHL',
      // Europe
      'london': 'LHR',
      'paris': 'CDG',
      'amsterdam': 'AMS',
      'frankfurt': 'FRA',
      'zurich': 'ZRH',
      'barcelona': 'BCN',
      'madrid': 'MAD',
      'rome': 'FCO',
      'milan': 'MIL',
      'berlin': 'BER',
      'vienna': 'VIE',
      'prague': 'PRG',
      'athens': 'ATH',
      'istanbul': 'IST',
      'dublin': 'DUB',
      // Asia
      'tokyo': 'TYO',
      'sydney': 'SYD',
      'dubai': 'DXB',
      'bangkok': 'BKK',
      'singapore': 'SIN',
      'hong kong': 'HKG',
      'mumbai': 'BOM',
      'delhi': 'DEL',
      'auckland': 'AKL',
      'melbourne': 'MEL',
      'dhaka': 'DAC',
      'kolkata': 'CCU',
      'bangalore': 'BLR',
      'new delhi': 'DEL',
      'hyderabad': 'HYD',
      'dubai airport': 'DXB',
      'abu dhabi': 'AUH',
      'doha': 'DOH',
      'seoul': 'ICN',
      'shanghai': 'PVG',
      'beijing': 'PEK',
    };
    return cityToCityCode[cityName];
  }

  /// Parse Amadeus hotel location response (from Hotel List by City API)
  /// API Response format:
  /// {
  ///   "data": [
  ///     {
  ///       "chainCode": "XX",
  ///       "iataCode": "NCE",
  ///       "name": "HOTEL NAME",
  ///       "hotelId": "XXNCE123",
  ///       "geoCode": { "latitude": 43.66, "longitude": 7.21 },
  ///       "address": { "countryCode": "FR" },
  ///       "distance": { "value": 0.92, "unit": "KM" }
  ///     }
  ///   ]
  /// }
  List<HotelModel> _parseAmadeusHotels(
    List<dynamic> hotelData,
    String city,
    int nights,
  ) {
    final List<HotelModel> hotels = [];
    
    for (final hotelItem in hotelData) {
      try {
        if (hotelItem is! Map<String, dynamic>) continue;

        // Extract required fields
        final hotelId = hotelItem['hotelId']?.toString() ?? '';
        final name = hotelItem['name']?.toString() ?? '';
        
        if (hotelId.isEmpty || name.isEmpty) continue;

        // Extract coordinates from geoCode
        final geoCode = hotelItem['geoCode'] as Map<String, dynamic>? ?? {};
        final latitude = double.tryParse(geoCode['latitude']?.toString() ?? '0') ?? 0.0;
        final longitude = double.tryParse(geoCode['longitude']?.toString() ?? '0') ?? 0.0;

        // Extract address info
        final address = hotelItem['address'] as Map<String, dynamic>? ?? {};
        final countryCode = address['countryCode']?.toString() ?? 'FR';

        // Extract distance
        final distance = hotelItem['distance'] as Map<String, dynamic>? ?? {};
        final distanceValue = double.tryParse(distance['value']?.toString() ?? '0') ?? 0.0;

        // Generate estimated price for display (Hotel List API doesn't include rates)
        final basePrice = 85.0 + (hotels.length * 8).toDouble();
        final pricePerNight = basePrice;

        hotels.add(HotelModel(
          id: hotelId,
          name: name.trim(),
          locationLat: latitude,
          locationLng: longitude,
          locationCity: city,
          locationCountry: countryCode,
          locationAddress: '${name.trim()}, $city, $countryCode',
          rating: 3.8 + (hotels.length % 3) * 0.4, // Estimated rating variation
          reviewCount: 150 + (hotels.length * 20),
          pricePerNight: pricePerNight,
          currency: 'USD',
          amenities: ['WiFi', 'Parking', 'Breakfast', 'Gym', 'Restaurant'],
          imageUrl: '',
          description: '${name.trim()} - ${distanceValue.toStringAsFixed(2)} km from city center',
          bookingUrl: '',
          distance: distanceValue,
        ));
      } catch (e) {
        // Skip malformed hotels
        AppLogger.warning('Failed to parse hotel location: $e');
        continue;
      }
    }
    
    AppLogger.info('Successfully parsed ${hotels.length} hotels from API response');
    return hotels;
  }

  @override
  Future<Either<Failure, List<Hotel>>> filterHotels({
    required List<Hotel> hotels,
    double? maxPrice,
    double? minRating,
    List<String>? amenities,
  }) async {
    try {
      // Convert domain entities to models for filtering
      var models = hotels
          .map((hotel) => HotelMapper.toPresentable(hotel))
          .toList();

      if (maxPrice != null) {
        models = models.where((h) => h.pricePerNight <= maxPrice).toList();
      }

      if (minRating != null) {
        models = models.where((h) => h.rating >= minRating).toList();
      }

      if (amenities != null && amenities.isNotEmpty) {
        models = models.where((h) {
          return amenities.any((a) => h.amenities.contains(a));
        }).toList();
      }

      return Right(HotelMapper.toDomainList(models));
    } catch (e) {
      return Left(NetworkFailure(message: 'Filter failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Hotel>>> getAvailableHotels({
    required String city,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      final nights = checkOutDate.difference(checkInDate).inDays;
      final hotels = _generateMockHotels(city, nights);

      return Right(HotelMapper.toDomainList(hotels));
    } catch (e) {
      return Left(NetworkFailure(message: 'Available hotels failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Hotel>>> getBestValueHotels({
    required String city,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      final allHotels = await searchHotels(
        city: city,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );

      return allHotels.fold(
        (failure) => Left(failure),
        (hotels) {
          // Sort by value (rating / price ratio)
          hotels.sort((a, b) {
            final aValue = a.rating / (a.pricePerNight > 0 ? a.pricePerNight : 1);
            final bValue = b.rating / (b.pricePerNight > 0 ? b.pricePerNight : 1);
            return bValue.compareTo(aValue);
          });
          return Right(hotels.take(5).toList());
        },
      );
    } catch (e) {
      return Left(NetworkFailure(message: 'Best value failed: ${e.toString()}'));
    }
  }

  List<HotelModel> _generateMockHotels(String city, int nights) {
    return [
      HotelModel(
        id: '1',
        name: '$city Luxury Hotel',
        locationLat: 40.7128,
        locationLng: -74.0060,
        locationCity: city,
        locationCountry: 'USA',
        locationAddress: '123 Main St, $city',
        rating: 4.8,
        reviewCount: 1250,
        pricePerNight: 180.0,
        currency: 'USD',
        amenities: ['WiFi', 'Pool', 'Gym', 'Restaurant'],
        imageUrl: 'https://example.com/hotel1.jpg',
        description: 'Luxury 5-star hotel in the heart of $city',
        bookingUrl: 'https://booking.example.com',
        distance: 0.5,
      ),
      HotelModel(
        id: '2',
        name: '$city Comfort Inn',
        locationLat: 40.7150,
        locationLng: -74.0050,
        locationCity: city,
        locationCountry: 'USA',
        locationAddress: '456 Oak Ave, $city',
        rating: 4.3,
        reviewCount: 890,
        pricePerNight: 95.0,
        currency: 'USD',
        amenities: ['WiFi', 'Gym', 'Parking'],
        imageUrl: 'https://example.com/hotel2.jpg',
        description: 'Comfortable 3-star hotel near downtown',
        bookingUrl: 'https://booking.example.com',
        distance: 2.3,
      ),
      HotelModel(
        id: '3',
        name: '$city Budget Rooms',
        locationLat: 40.7200,
        locationLng: -74.0040,
        locationCity: city,
        locationCountry: 'USA',
        locationAddress: '789 Pine St, $city',
        rating: 3.9,
        reviewCount: 456,
        pricePerNight: 55.0,
        currency: 'USD',
        amenities: ['WiFi', 'Parking'],
        imageUrl: 'https://example.com/hotel3.jpg',
        description: 'Budget-friendly accommodation',
        bookingUrl: 'https://booking.example.com',
        distance: 4.8,
      ),
    ];
  }
}
