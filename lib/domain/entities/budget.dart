import 'package:equatable/equatable.dart';

/// Represents a budget allocation for a trip
class BudgetItem extends Equatable {
  final String id;
  final String category; // 'flights', 'hotels', 'activities', 'meals', 'transport', 'other'
  final double allocatedAmount;
  final double spentAmount;
  final String currency;
  final String? notes;

  const BudgetItem({
    required this.id,
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.currency,
    this.notes,
  });

  double get remainingAmount => allocatedAmount - spentAmount;
  double get percentageUsed => allocatedAmount > 0 ? (spentAmount / allocatedAmount) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        category,
        allocatedAmount,
        spentAmount,
        currency,
        notes,
      ];
}

/// Represents overall budget tracking for a trip
class Budget extends Equatable {
  final String id;
  final String tripId;
  final double totalBudget;
  final String currency;
  final List<BudgetItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.tripId,
    required this.totalBudget,
    required this.currency,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalSpent => items.fold(0, (sum, item) => sum + item.spentAmount);
  double get totalRemaining => totalBudget - totalSpent;
  double get percentageUsed => totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        tripId,
        totalBudget,
        currency,
        items,
        createdAt,
        updatedAt,
      ];
}
