import 'package:equatable/equatable.dart';

class TravelRecommendation extends Equatable {
  final String destination;
  final String recommendation;
  final DateTime generatedAt;
  final String type; // 'general', 'activity', 'dining', 'itinerary'

  const TravelRecommendation({
    required this.destination,
    required this.recommendation,
    required this.generatedAt,
    required this.type,
  });

  @override
  List<Object?> get props => [destination, recommendation, generatedAt, type];
}
