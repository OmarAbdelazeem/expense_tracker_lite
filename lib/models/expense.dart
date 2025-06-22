import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final double convertedAmount; // Amount in USD

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? receiptPath;

  @HiveField(7)
  final String? description;

  const Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.date,
    this.receiptPath,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        currency,
        convertedAmount,
        date,
        receiptPath,
        description,
      ];

  Expense copyWith({
    String? id,
    String? category,
    double? amount,
    String? currency,
    double? convertedAmount,
    DateTime? date,
    String? receiptPath,
    String? description,
  }) {
    return Expense(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      description: description ?? this.description,
    );
  }
} 