/// Data model for ItineraryItem
class ItineraryItemModel {
  final String id;
  final int dayNumber;
  final String title;
  final String? description;
  final DateTime scheduledTime;
  final String? location;
  final String? category;
  final String? notes;

  ItineraryItemModel({
    required this.id,
    required this.dayNumber,
    required this.title,
    this.description,
    required this.scheduledTime,
    this.location,
    this.category,
    this.notes,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    return ItineraryItemModel(
      id: json['id'] as String,
      dayNumber: json['dayNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      location: json['location'] as String?,
      category: json['category'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dayNumber': dayNumber,
        'title': title,
        'description': description,
        'scheduledTime': scheduledTime.toIso8601String(),
        'location': location,
        'category': category,
        'notes': notes,
      };
}

/// Data model for Trip
class TripModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final List<String> destinations;
  final String? outboundFlightJson;
  final String? returnFlightJson;
  final String? hotelsJson;
  final String? activitiesJson;
  final List<ItineraryItemModel> itinerary;
  final String? budgetJson;
  final String status;
  final int numberOfPeople;
  final String? coverImageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  TripModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.destinations,
    this.outboundFlightJson,
    this.returnFlightJson,
    this.hotelsJson,
    this.activitiesJson,
    required this.itinerary,
    this.budgetJson,
    required this.status,
    required this.numberOfPeople,
    this.coverImageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      destination: json['destination'] as String,
      destinations: List<String>.from(json['destinations'] as List),
      outboundFlightJson: json['outboundFlightJson'] as String?,
      returnFlightJson: json['returnFlightJson'] as String?,
      hotelsJson: json['hotelsJson'] as String?,
      activitiesJson: json['activitiesJson'] as String?,
      itinerary: (json['itinerary'] as List)
          .map((item) => ItineraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      budgetJson: json['budgetJson'] as String?,
      status: json['status'] as String,
      numberOfPeople: json['numberOfPeople'] as int,
      coverImageUrl: json['coverImageUrl'] as String?,
      tags: List<String>.from(json['tags'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'destination': destination,
        'destinations': destinations,
        'outboundFlightJson': outboundFlightJson,
        'returnFlightJson': returnFlightJson,
        'hotelsJson': hotelsJson,
        'activitiesJson': activitiesJson,
        'itinerary': itinerary.map((item) => item.toJson()).toList(),
        'budgetJson': budgetJson,
        'status': status,
        'numberOfPeople': numberOfPeople,
        'coverImageUrl': coverImageUrl,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
