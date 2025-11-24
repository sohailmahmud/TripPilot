import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_pilot/domain/repositories/activity_search_service.dart';
import 'package:trip_pilot/domain/repositories/flight_search_service.dart';
import 'package:trip_pilot/domain/repositories/hotel_search_service.dart';
import 'package:trip_pilot/presentation/bloc/search/search_event.dart';
import 'package:trip_pilot/presentation/bloc/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FlightSearchService flightSearchService;
  final HotelSearchService hotelSearchService;
  final ActivitySearchService activitySearchService;

  SearchBloc({
    required this.flightSearchService,
    required this.hotelSearchService,
    required this.activitySearchService,
  }) : super(const SearchInitial()) {
    on<SearchFlightsRequested>(_onSearchFlightsRequested);
    on<SearchHotelsRequested>(_onSearchHotelsRequested);
    on<SearchActivitiesRequested>(_onSearchActivitiesRequested);
    on<ClearSearchResults>(_onClearSearchResults);
    on<ApplyFilters>(_onApplyFilters);
  }

  Future<void> _onSearchFlightsRequested(
    SearchFlightsRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading(searchType: 'flights'));

    final result = await flightSearchService.searchFlights(
      departureCity: event.departureCity,
      arrivalCity: event.arrivalCity,
      departureDate: event.departureDate,
      returnDate: event.returnDate,
      numberOfPassengers: event.numberOfPassengers,
    );

    result.fold(
      (failure) => emit(SearchFailure(failure)),
      (flights) {
        if (flights.isEmpty) {
          emit(SearchEmpty(
              message:
                  'No flights found from ${event.departureCity} to ${event.arrivalCity}'));
        } else {
          emit(FlightsSearchSuccess(
            flights: flights,
            totalResults: flights.length,
          ));
        }
      },
    );
  }

  Future<void> _onSearchHotelsRequested(
    SearchHotelsRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading(searchType: 'hotels'));

    final result = await hotelSearchService.searchHotels(
      city: event.city,
      checkInDate: event.checkInDate,
      checkOutDate: event.checkOutDate,
      numberOfGuests: event.numberOfGuests,
    );

    result.fold(
      (failure) => emit(SearchFailure(failure)),
      (hotels) {
        if (hotels.isEmpty) {
          emit(SearchEmpty(message: 'No hotels found in ${event.city}'));
        } else {
          emit(HotelsSearchSuccess(
            hotels: hotels,
            totalResults: hotels.length,
          ));
        }
      },
    );
  }

  Future<void> _onSearchActivitiesRequested(
    SearchActivitiesRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading(searchType: 'activities'));

    final result = await activitySearchService.searchActivities(
      city: event.city,
      category: event.category,
    );

    result.fold(
      (failure) => emit(SearchFailure(failure)),
      (activities) {
        if (activities.isEmpty) {
          emit(SearchEmpty(message: 'No activities found in ${event.city}'));
        } else {
          emit(ActivitiesSearchSuccess(
            activities: activities,
            totalResults: activities.length,
          ));
        }
      },
    );
  }

  Future<void> _onClearSearchResults(
    ClearSearchResults event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchInitial());
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    // Filter logic applied to current state
    if (state is FlightsSearchSuccess) {
      final currentState = state as FlightsSearchSuccess;
      final result = await flightSearchService.filterFlights(
        flights: currentState.flights,
        maxPrice: event.maxPrice,
        preferredAirlines: event.airlines,
      );

      result.fold(
        (failure) => emit(SearchFailure(failure)),
        (flights) => emit(FlightsSearchSuccess(
          flights: flights,
          totalResults: flights.length,
        )),
      );
    }
  }
}
