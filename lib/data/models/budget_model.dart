/// Data model for BudgetItem
class BudgetItemModel {
  final String id;
  final String category;
  final double allocatedAmount;
  final double spentAmount;
  final String currency;
  final String? notes;

  BudgetItemModel({
    required this.id,
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.currency,
    this.notes,
  });

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) {
    return BudgetItemModel(
      id: json['id'] as String,
      category: json['category'] as String,
      allocatedAmount: (json['allocatedAmount'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'allocatedAmount': allocatedAmount,
        'spentAmount': spentAmount,
        'currency': currency,
        'notes': notes,
      };
}

/// Data model for Budget
class BudgetModel {
  final String id;
  final String tripId;
  final double totalBudget;
  final String currency;
  final List<BudgetItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    required this.id,
    required this.tripId,
    required this.totalBudget,
    required this.currency,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      totalBudget: (json['totalBudget'] as num).toDouble(),
      currency: json['currency'] as String,
      items: (json['items'] as List)
          .map((item) => BudgetItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'totalBudget': totalBudget,
        'currency': currency,
        'items': items.map((item) => item.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
