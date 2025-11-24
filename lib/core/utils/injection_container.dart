import 'package:get_it/get_it.dart';
import 'package:trip_pilot/core/config/supabase_config.dart';
import 'package:trip_pilot/data/datasources/remote/amadeus_flight_service.dart';
import 'package:trip_pilot/data/datasources/remote/amadeus_activities_service.dart';
import 'package:trip_pilot/data/datasources/remote/ai_recommendation_service.dart';
import 'package:trip_pilot/data/datasources/remote/flight_search_service.dart';
import 'package:trip_pilot/data/datasources/remote/amadeus_hotel_service.dart';
import 'package:trip_pilot/data/datasources/remote/hotel_search_service.dart';
import 'package:trip_pilot/data/datasources/remote/supabase_auth_service.dart';
import 'package:trip_pilot/data/datasources/remote/supabase_trips_service.dart';
import 'package:trip_pilot/data/repositories/auth_repository_impl.dart';
import 'package:trip_pilot/data/repositories/trip_repository_impl.dart';
import 'package:trip_pilot/domain/repositories/ai_recommendation_service.dart';
import 'package:trip_pilot/domain/repositories/auth_repository.dart';
import 'package:trip_pilot/domain/repositories/flight_search_service.dart';
import 'package:trip_pilot/domain/repositories/hotel_search_service.dart';
import 'package:trip_pilot/domain/repositories/activity_search_service.dart';
import 'package:trip_pilot/domain/repositories/trip_repository.dart';
import 'package:trip_pilot/presentation/bloc/auth/auth_bloc.dart';
import 'package:trip_pilot/presentation/bloc/budget/budget_bloc.dart';
import 'package:trip_pilot/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:trip_pilot/presentation/bloc/recommendations/recommendations_bloc.dart';
import 'package:trip_pilot/presentation/bloc/search/search_bloc.dart';
import 'package:trip_pilot/presentation/bloc/trip/trip_bloc.dart';
import 'package:trip_pilot/data/datasources/remote/activity_search_service.dart' as remote_activity;
import 'package:trip_pilot/data/repositories/activity_search_service_impl.dart';
import '../config/api_client_config.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies for the application
void setupServiceLocator() {
  // External
  final supabaseClient = SupabaseConfig.client;

  // Data Sources
  getIt.registerSingleton<SupabaseAuthService>(
    SupabaseAuthService(client: supabaseClient),
  );

  getIt.registerSingleton<SupabaseTripsService>(
    SupabaseTripsService(client: supabaseClient),
  );

  // API Services for dynamic search
  getIt.registerSingleton<AmadeusFlightService>(
    AmadeusFlightService(
      clientId: ApiClientConfig.amadeusClientId,
      clientSecret: ApiClientConfig.amadeusClientSecret
    ),
  );

  getIt.registerSingleton<AmadeusHotelService>(
    AmadeusHotelService(
      clientId: ApiClientConfig.amadeusClientId,
      clientSecret: ApiClientConfig.amadeusClientSecret,
    ),
  );

  getIt.registerSingleton<AmadeusActivitiesService>(
    AmadeusActivitiesService(
      clientId: ApiClientConfig.amadeusClientId,
      clientSecret: ApiClientConfig.amadeusClientSecret,
    ),
  );

  // Search Services
  getIt.registerSingleton<FlightSearchService>(
    FlightSearchServiceImpl(
      amadeusService: getIt<AmadeusFlightService>(),
    ),
  );

  getIt.registerSingleton<HotelSearchService>(
    HotelSearchServiceImpl(
      hotelApiService: getIt<AmadeusHotelService>(),
    ),
  );

  getIt.registerSingleton<remote_activity.ActivitySearchService>(
    remote_activity.ActivitySearchService(
      amadeusService: getIt<AmadeusActivitiesService>(),
    ),
  );

  getIt.registerSingleton<ActivitySearchService>(
    ActivitySearchServiceImpl(
      activityApiService: getIt<remote_activity.ActivitySearchService>(),
    ),
  );

  // AI Service
  getIt.registerSingleton<AIRecommendationService>(
    AIRecommendationServiceImpl(),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authService: getIt<SupabaseAuthService>()),
  );

  getIt.registerSingleton<TripRepository>(
    TripRepositoryImpl(supabaseService: getIt<SupabaseTripsService>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<TripBloc>(
    TripBloc(tripRepository: getIt<TripRepository>()),
  );

  getIt.registerSingleton<SearchBloc>(
    SearchBloc(
      flightSearchService: getIt<FlightSearchService>(),
      hotelSearchService: getIt<HotelSearchService>(),
      activitySearchService: getIt<ActivitySearchService>(),
    ),
  );

  getIt.registerSingleton<RecommendationBloc>(
    RecommendationBloc(aiService: getIt<AIRecommendationService>()),
  );

  getIt.registerSingleton<BudgetBloc>(
    BudgetBloc(),
  );

  getIt.registerSingleton<NavigationBloc>(
    NavigationBloc(),
  );

  // Register UseCases
}
