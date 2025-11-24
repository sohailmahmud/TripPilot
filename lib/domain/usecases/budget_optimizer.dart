import 'package:trip_pilot/domain/entities/travel_entities.dart';

/// Budget breakdown for a trip
class TripBudgetBreakdown {
  final double totalBudget;
  final double flightCost;
  final double hotelCost;
  final double activitiesCost;
  final double foodEstimate;
  final double transportEstimate;
  final double contingency;
  final Map<String, double> itemCosts;

  double get totalAllocated =>
      flightCost + hotelCost + activitiesCost + foodEstimate + transportEstimate + contingency;
  double get remaining => totalBudget - totalAllocated;
  double get percentageUsed => (totalAllocated / totalBudget) * 100;

  TripBudgetBreakdown({
    required this.totalBudget,
    required this.flightCost,
    required this.hotelCost,
    required this.activitiesCost,
    required this.foodEstimate,
    required this.transportEstimate,
    required this.contingency,
    this.itemCosts = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'totalBudget': totalBudget,
      'flightCost': flightCost,
      'hotelCost': hotelCost,
      'activitiesCost': activitiesCost,
      'foodEstimate': foodEstimate,
      'transportEstimate': transportEstimate,
      'contingency': contingency,
      'totalAllocated': totalAllocated,
      'remaining': remaining,
      'percentageUsed': percentageUsed,
      'itemCosts': itemCosts,
    };
  }
}

/// Deal detection model
class DealInfo {
  final String title;
  final String description;
  final double savingsAmount;
  final double savingsPercentage;
  final String recommendationType; // 'flight', 'hotel', 'activity', 'package'
  final int daysUntilExpiry; // -1 if no expiry
  final String? dealUrl;

  DealInfo({
    required this.title,
    required this.description,
    required this.savingsAmount,
    required this.savingsPercentage,
    required this.recommendationType,
    required this.daysUntilExpiry,
    this.dealUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'savingsAmount': savingsAmount,
      'savingsPercentage': savingsPercentage,
      'recommendationType': recommendationType,
      'daysUntilExpiry': daysUntilExpiry,
      'dealUrl': dealUrl,
    };
  }
}

/// Budget optimization service
class BudgetOptimizer {
  /// Calculate optimal budget breakdown for a trip
  static TripBudgetBreakdown optimizeBudget({
    required double totalBudget,
    required int numberOfDays,
    required int numberOfPeople,
    Flight? outboundFlight,
    Flight? returnFlight,
    List<Hotel>? hotels,
    List<Activity>? activities,
  }) {
    // Allocate budget percentages
    final flightPercentage = 0.30; // 30% for flights
    final hotelPercentage = 0.35; // 35% for accommodation
    final activitiesPercentage = 0.15; // 15% for activities
    final foodPercentage = 0.12; // 12% for food
    final transportPercentage = 0.05; // 5% for local transport
    final contingencyPercentage = 0.03; // 3% contingency

    final flightBudget = totalBudget * flightPercentage;
    final hotelBudget = totalBudget * hotelPercentage;
    final activitiesBudget = totalBudget * activitiesPercentage;
    final foodBudget = totalBudget * foodPercentage;
    final transportBudget = totalBudget * transportPercentage;
    final contingency = totalBudget * contingencyPercentage;

    // Calculate actual costs if items provided
    double actualFlightCost = 0;
    if (outboundFlight != null) {
      actualFlightCost += outboundFlight.price * numberOfPeople;
    }
    if (returnFlight != null) {
      actualFlightCost += returnFlight.price * numberOfPeople;
    }

    double actualHotelCost = 0;
    if (hotels != null && hotels.isNotEmpty) {
      final cheapestHotel = hotels.reduce((a, b) => a.pricePerNight < b.pricePerNight ? a : b);
      actualHotelCost = cheapestHotel.pricePerNight * numberOfDays * numberOfPeople;
    }

    double actualActivitiesCost = 0;
    if (activities != null && activities.isNotEmpty) {
      actualActivitiesCost = activities.fold(0.0, (sum, activity) => sum + (activity.price ?? 0));
    }

    return TripBudgetBreakdown(
      totalBudget: totalBudget,
      flightCost: actualFlightCost > 0 ? actualFlightCost : flightBudget,
      hotelCost: actualHotelCost > 0 ? actualHotelCost : hotelBudget,
      activitiesCost: actualActivitiesCost > 0 ? actualActivitiesCost : activitiesBudget,
      foodEstimate: foodBudget,
      transportEstimate: transportBudget,
      contingency: contingency,
    );
  }

  /// Detect deals in flight options
  static List<DealInfo> detectFlightDeals(List<Flight> flights) {
    final deals = <DealInfo>[];

    if (flights.isEmpty) return deals;

    // Find average price
    final averagePrice = flights.fold(0.0, (sum, f) => sum + f.price) / flights.length;

    // Find cheapest flight
    final cheapest = flights.reduce((a, b) => a.price < b.price ? a : b);
    final savings = averagePrice - cheapest.price;
    final savingsPercent = (savings / averagePrice) * 100;

    if (savingsPercent > 10) {
      deals.add(
        DealInfo(
          title: 'Budget Flight Deal',
          description: '${cheapest.airline} ${cheapest.flightNumber} - Save \$${savings.toStringAsFixed(2)}',
          savingsAmount: savings,
          savingsPercentage: savingsPercent,
          recommendationType: 'flight',
          daysUntilExpiry: 7,
          dealUrl: cheapest.bookingUrl,
        ),
      );
    }

    // Detect short-duration deals
    final shortestFlight = flights.reduce((a, b) => a.duration < b.duration ? a : b);
    final averageDuration = flights.fold(0.0, (sum, f) => sum + f.duration) / flights.length;

    if (shortestFlight.duration < averageDuration * 0.8) {
      deals.add(
        DealInfo(
          title: 'Quick Flight Deal',
          description: '${shortestFlight.airline} - Only ${(shortestFlight.duration / 60).toStringAsFixed(1)} hours',
          savingsAmount: (averageDuration - shortestFlight.duration) / 60 * 10,
          savingsPercentage: ((averageDuration - shortestFlight.duration) / averageDuration) * 100,
          recommendationType: 'flight',
          daysUntilExpiry: 5,
          dealUrl: shortestFlight.bookingUrl,
        ),
      );
    }

    return deals;
  }

  /// Detect deals in hotel options
  static List<DealInfo> detectHotelDeals(List<Hotel> hotels) {
    final deals = <DealInfo>[];

    if (hotels.isEmpty) return deals;

    // Find average price
    final averagePrice = hotels.fold(0.0, (sum, h) => sum + h.pricePerNight) / hotels.length;

    // Find cheapest hotel
    final cheapest = hotels.reduce((a, b) => a.pricePerNight < b.pricePerNight ? a : b);
    final savings = averagePrice - cheapest.pricePerNight;
    final savingsPercent = (savings / averagePrice) * 100;

    if (savingsPercent > 15) {
      deals.add(
        DealInfo(
          title: 'Budget Hotel Deal',
          description: '${cheapest.name} - \$${cheapest.pricePerNight.toStringAsFixed(2)}/night',
          savingsAmount: savings,
          savingsPercentage: savingsPercent,
          recommendationType: 'hotel',
          daysUntilExpiry: 3,
          dealUrl: cheapest.bookingUrl,
        ),
      );
    }

    // Detect high-rating budget deals
    final goodValue = hotels.where((h) => h.rating >= 4.5).toList();
    if (goodValue.isNotEmpty) {
      final bestValue = goodValue.reduce((a, b) {
        final aRatio = a.rating / a.pricePerNight;
        final bRatio = b.rating / b.pricePerNight;
        return aRatio > bRatio ? a : b;
      });

      deals.add(
        DealInfo(
          title: 'Best Value Hotel',
          description: '${bestValue.name} - ${bestValue.rating} rating at \$${bestValue.pricePerNight.toStringAsFixed(2)}/night',
          savingsAmount: averagePrice - bestValue.pricePerNight,
          savingsPercentage: ((averagePrice - bestValue.pricePerNight) / averagePrice) * 100,
          recommendationType: 'hotel',
          daysUntilExpiry: 2,
          dealUrl: bestValue.bookingUrl,
        ),
      );
    }

    return deals;
  }

  /// Detect deals in activities
  static List<DealInfo> detectActivityDeals(List<Activity> activities) {
    final deals = <DealInfo>[];

    if (activities.isEmpty) return deals;

    // Find average price
    final averagePrice = activities.fold(0.0, (sum, a) => sum + (a.price ?? 0)) / activities.length;

    // Find cheapest activity
    final cheapest = activities.reduce((a, b) {
      final aPrice = a.price ?? 0;
      final bPrice = b.price ?? 0;
      return aPrice < bPrice ? a : b;
    });

    final cheapestPrice = cheapest.price ?? 0;
    if (cheapestPrice > 0) {
      final savings = averagePrice - cheapestPrice;
      final savingsPercent = (savings / averagePrice) * 100;

      if (savingsPercent > 20) {
        deals.add(
          DealInfo(
            title: 'Budget Activity',
            description: '${cheapest.name} - Only \$${cheapestPrice.toStringAsFixed(2)}',
            savingsAmount: savings,
            savingsPercentage: savingsPercent,
            recommendationType: 'activity',
            daysUntilExpiry: 1,
            dealUrl: cheapest.bookingUrl,
          ),
        );
      }
    }

    // Detect top-rated activities
    final topRated = activities.where((a) => (a.rating ?? 0) >= 4.7).toList();
    if (topRated.isNotEmpty) {
      final best = topRated.first;
      deals.add(
        DealInfo(
          title: 'Top-Rated Experience',
          description: '${best.name} - ${best.rating} rating',
          savingsAmount: 0,
          savingsPercentage: 0,
          recommendationType: 'activity',
          daysUntilExpiry: 10,
          dealUrl: best.bookingUrl,
        ),
      );
    }

    return deals;
  }

  /// Compare multiple trip options based on total cost
  static Map<String, dynamic> compareTripOptions({
    required List<Flight> flights,
    required List<Hotel> hotels,
    required List<Activity> activities,
    required int numberOfDays,
    required int numberOfPeople,
  }) {
    final tripOptions = <Map<String, dynamic>>[];

    // Generate combinations of flights and hotels
    for (final flight in flights) {
      for (final hotel in hotels) {
        final flightCost = flight.price * numberOfPeople;
        final hotelCost = hotel.pricePerNight * numberOfDays * numberOfPeople;
        final activitiesCost =
            activities.isEmpty ? 0 : (activities.first.price ?? 0) * numberOfPeople;

        final totalCost = flightCost + hotelCost + activitiesCost;

        tripOptions.add({
          'flight': flight.flightNumber,
          'hotel': hotel.name,
          'activity': activities.isEmpty ? 'None' : activities.first.name,
          'flightCost': flightCost,
          'hotelCost': hotelCost,
          'activitiesCost': activitiesCost,
          'totalCost': totalCost,
          'rating': (flight.price > 0 ? 100 - (flight.price / 10) : 0) +
              hotel.rating, // Simple scoring
        });
      }
    }

    // Sort by total cost
    tripOptions.sort((a, b) => (a['totalCost'] as double).compareTo(b['totalCost'] as double));

    return {
      'cheapestOption': tripOptions.isNotEmpty ? tripOptions.first : null,
      'mostExpensiveOption': tripOptions.isNotEmpty ? tripOptions.last : null,
      'averageCost': tripOptions.isEmpty
          ? 0
          : tripOptions.fold(0.0, (sum, opt) => sum + (opt['totalCost'] as double)) /
              tripOptions.length,
      'allOptions': tripOptions,
      'totalOptions': tripOptions.length,
    };
  }

  /// Get budget recommendations based on available options
  static List<String> getBudgetRecommendations({
    required double budget,
    required TripBudgetBreakdown breakdown,
    required List<DealInfo> deals,
  }) {
    final recommendations = <String>[];

    // Check if budget is sufficient
    if (breakdown.remaining < 0) {
      recommendations.add(
        'Budget exceeded by \$${(-breakdown.remaining).toStringAsFixed(2)}. Consider longer stays in budget hotels or fewer activities.',
      );
    } else if (breakdown.remaining < budget * 0.05) {
      recommendations.add(
        'Limited budget remaining. Focus on must-do activities.',
      );
    } else {
      recommendations.add(
        'Good budget balance! You have \$${breakdown.remaining.toStringAsFixed(2)} for flexibility.',
      );
    }

    // Deal recommendations
    if (deals.isNotEmpty) {
      for (final deal in deals.take(3)) {
        recommendations.add(
          'DEAL: ${deal.title} - Save ${deal.savingsPercentage.toStringAsFixed(1)}%',
        );
      }
    }

    // Category-specific recommendations
    if (breakdown.flightCost > breakdown.totalBudget * 0.35) {
      recommendations.add(
        'Flights are consuming ${((breakdown.flightCost / breakdown.totalBudget) * 100).toStringAsFixed(1)}% of budget. Consider cheaper airlines or earlier booking.',
      );
    }

    if (breakdown.hotelCost > breakdown.totalBudget * 0.40) {
      recommendations.add(
        'Accommodation is ${((breakdown.hotelCost / breakdown.totalBudget) * 100).toStringAsFixed(1)}% of budget. Consider budget hotels or fewer nights.',
      );
    }

    return recommendations;
  }
}
