import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class StorageService {
  static const String _expensesBoxName = 'expenses';
  static Box<Expense>? _expensesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
    
    // Open boxes
    _expensesBox = await Hive.openBox<Expense>(_expensesBoxName);
  }

  static Box<Expense> get expensesBox {
    if (_expensesBox == null || !_expensesBox!.isOpen) {
      throw Exception('Expenses box is not initialized. Call StorageService.init() first.');
    }
    return _expensesBox!;
  }

  // Expense operations
  Future<void> addExpense(Expense expense) async {
    await expensesBox.put(expense.id, expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await expensesBox.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await expensesBox.delete(id);
  }

  List<Expense> getAllExpenses() {
    return expensesBox.values.toList();
  }

  List<Expense> getExpensesByDateRange(DateTime startDate, DateTime endDate) {
    return expensesBox.values
        .where((expense) =>
            expense.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            expense.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  List<Expense> getExpensesPaginated({
    required int page,
    required int limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    List<Expense> expenses = getAllExpenses();
    
    // Filter by date range if provided
    if (startDate != null && endDate != null) {
      expenses = expenses
          .where((expense) =>
              expense.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }
    
    // Sort by date (newest first)
    expenses.sort((a, b) => b.date.compareTo(a.date));
    
    // Apply pagination
    final startIndex = page * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= expenses.length) {
      return [];
    }
    
    return expenses.sublist(
      startIndex,
      endIndex > expenses.length ? expenses.length : endIndex,
    );
  }

  int getTotalExpenseCount({DateTime? startDate, DateTime? endDate}) {
    if (startDate != null && endDate != null) {
      return getExpensesByDateRange(startDate, endDate).length;
    }
    return expensesBox.length;
  }

  double getTotalExpensesAmount({DateTime? startDate, DateTime? endDate}) {
    List<Expense> expenses;
    
    if (startDate != null && endDate != null) {
      expenses = getExpensesByDateRange(startDate, endDate);
    } else {
      expenses = getAllExpenses();
    }
    
    return expenses.fold(0.0, (sum, expense) => sum + expense.convertedAmount);
  }

  Future<void> clearAllExpenses() async {
    await expensesBox.clear();
  }

  static Future<void> close() async {
    await _expensesBox?.close();
  }
} 