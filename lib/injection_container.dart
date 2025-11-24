import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'data/datasources/remote/ai_recommendation_service.dart';
import 'domain/repositories/ai_recommendation_service.dart';
import 'presentation/bloc/recommendations/recommendations_bloc.dart';

final getIt = GetIt.instance;

void setupOpenAIServices() {
  // Services
  getIt.registerSingleton<Logger>(Logger());
  
  // Datasources & Repositories
  getIt.registerSingleton<AIRecommendationService>(
    AIRecommendationServiceImpl(
      dio: Dio(),
      logger: getIt<Logger>(),
    ),
  );

  // BLoCs
  getIt.registerSingleton<RecommendationBloc>(
    RecommendationBloc(aiService: getIt<AIRecommendationService>()),
  );
}
