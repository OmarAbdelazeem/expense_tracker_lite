import '../models/expense.dart';

class SampleData {
  static Future<void> addSampleExpenses(Function(Expense) addExpense) async {
    final sampleExpenses = [
      Expense(
        id: '1',
        category: 'Groceries',
        amount: 100.00,
        currency: 'USD',
        convertedAmount: 100.00,
        date: DateTime.now().subtract(const Duration(hours: 1)),
        description: 'Weekly grocery shopping',
      ),
      Expense(
        id: '2',
        category: 'Entertainment',
        amount: 100.00,
        currency: 'USD',
        convertedAmount: 100.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Movie tickets',
      ),
      Expense(
        id: '3',
        category: 'Transport',
        amount: 100.00,
        currency: 'USD',
        convertedAmount: 100.00,
        date: DateTime.now().subtract(const Duration(hours: 3)),
        description: 'Taxi fare',
      ),
      Expense(
        id: '4',
        category: 'Rent',
        amount: 100.00,
        currency: 'USD',
        convertedAmount: 100.00,
        date: DateTime.now().subtract(const Duration(hours: 4)),
        description: 'Monthly rent payment',
      ),
    ];

    for (final expense in sampleExpenses) {
      await addExpense(expense);
      // Add delay to avoid conflicts
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
} 