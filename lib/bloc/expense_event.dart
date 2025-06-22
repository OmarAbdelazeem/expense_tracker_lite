import 'package:equatable/equatable.dart';
import '../models/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final int limit;

  const LoadExpenses({
    this.startDate,
    this.endDate,
    this.page = 0,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [startDate, endDate, page, limit];
}

class LoadMoreExpenses extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadMoreExpenses({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  const AddExpense({required this.expense});

  @override
  List<Object> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  const UpdateExpense({required this.expense});

  @override
  List<Object> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  const DeleteExpense({required this.expenseId});

  @override
  List<Object> get props => [expenseId];
}

class FilterExpenses extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterExpenses({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class RefreshExpenses extends ExpenseEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const RefreshExpenses({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
} 