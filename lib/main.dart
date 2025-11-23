import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trip_pilot/core/configs/supabase_config.dart';
import 'package:trip_pilot/core/theme/app_theme.dart';
import 'package:trip_pilot/core/utils/injection_container.dart';
import 'package:trip_pilot/core/utils/logger_util.dart';
import 'package:trip_pilot/core/router/app_router.dart';
import 'package:trip_pilot/data/local/local_database.dart';
import 'package:trip_pilot/presentation/bloc/auth/auth_bloc.dart';
import 'package:trip_pilot/presentation/bloc/budget/budget_bloc.dart';
import 'package:trip_pilot/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:trip_pilot/presentation/bloc/recommendations/recommendations_bloc.dart';
import 'package:trip_pilot/presentation/bloc/search/search_bloc.dart';
import 'package:trip_pilot/presentation/bloc/trip/trip_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load();
  
  // Initialize ObjectBox for offline-first caching
  try {
    await LocalDatabase.initialize();
    AppLogger.info('ObjectBox database initialized successfully');
  } catch (e) {
    AppLogger.error('Failed to initialize ObjectBox database', error: e);
  }
  
  // Initialize Supabase
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    AppLogger.error('Failed to initialize Supabase', error: e);
  }
  
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<SearchBloc>(create: (context) => getIt<SearchBloc>()),
        BlocProvider<TripBloc>(create: (context) => getIt<TripBloc>()),
        BlocProvider<BudgetBloc>(create: (context) => getIt<BudgetBloc>()),
        BlocProvider<RecommendationBloc>(create: (context) => getIt<RecommendationBloc>()),
        BlocProvider<NavigationBloc>(create: (context) => getIt<NavigationBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Trip Pilot',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
      ),
    );
  }
}