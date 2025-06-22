import 'package:equatable/equatable.dart';
import '../models/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double totalAmount;
  final int currentPage;
  final bool hasMore;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final bool isLoadingMore;

  const ExpenseLoaded({
    required this.expenses,
    required this.totalAmount,
    this.currentPage = 0,
    this.hasMore = false,
    this.filterStartDate,
    this.filterEndDate,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        expenses,
        totalAmount,
        currentPage,
        hasMore,
        filterStartDate,
        filterEndDate,
        isLoadingMore,
      ];

  ExpenseLoaded copyWith({
    List<Expense>? expenses,
    double? totalAmount,
    int? currentPage,
    bool? hasMore,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    bool? isLoadingMore,
  }) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      totalAmount: totalAmount ?? this.totalAmount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ExpenseLoadingMore extends ExpenseState {
  final List<Expense> expenses;
  final double totalAmount;
  final int currentPage;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  const ExpenseLoadingMore({
    required this.expenses,
    required this.totalAmount,
    required this.currentPage,
    this.filterStartDate,
    this.filterEndDate,
  });

  @override
  List<Object?> get props => [
        expenses,
        totalAmount,
        currentPage,
        filterStartDate,
        filterEndDate,
      ];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError({required this.message});

  @override
  List<Object> get props => [message];
}

class ExpenseOperationSuccess extends ExpenseState {
  final String message;
  final List<Expense> expenses;
  final double totalAmount;

  const ExpenseOperationSuccess({
    required this.message,
    required this.expenses,
    required this.totalAmount,
  });

  @override
  List<Object> get props => [message, expenses, totalAmount];
} 