import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum Category { food, transport, shopping, entertainment, health, other }

const categoryIcons = {
  Category.food: '🍔',
  Category.transport: '🚗',
  Category.shopping: '🛍️',
  Category.entertainment: '🎬',
  Category.health: '💊',
  Category.other: '📦',
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = _uuid.v4();

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  String get categoryIcon => categoryIcons[category] ?? '📦';

  String get categoryName =>
      category.name[0].toUpperCase() + category.name.substring(1);
}
