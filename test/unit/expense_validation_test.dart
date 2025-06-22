import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_lite/models/expense.dart';
import 'package:expense_tracker_lite/models/category.dart';

void main() {
  group('Expense Validation Tests', () {
    late Expense validExpense;

    setUp(() {
      validExpense = Expense(
        id: '1',
        category: 'Groceries',
        amount: 50.0,
        currency: 'USD',
        convertedAmount: 50.0,
        date: DateTime.now(),
        description: 'Test expense',
      );
    });

    group('Amount Validation', () {
      test('should accept valid positive amounts', () {
        expect(validExpense.amount, 50.0);
        expect(validExpense.amount > 0, true);
      });

      test('should handle decimal amounts correctly', () {
        final expense = validExpense.copyWith(amount: 25.99);
        expect(expense.amount, 25.99);
      });

      test('should handle large amounts', () {
        final expense = validExpense.copyWith(amount: 999999.99);
        expect(expense.amount, 999999.99);
      });

      test('should handle small amounts', () {
        final expense = validExpense.copyWith(amount: 0.01);
        expect(expense.amount, 0.01);
      });

      test('should validate amount precision', () {
        final expense = validExpense.copyWith(amount: 10.123456789);
        // Should be able to store high precision
        expect(expense.amount, 10.123456789);
      });
    });

    group('Category Validation', () {
      test('should accept all valid categories', () {
        for (final category in Category.predefinedCategories) {
          final expense = validExpense.copyWith(category: category.name);
          expect(expense.category, category.name);
          expect(Category.predefinedCategories.any((c) => c.name == expense.category), true);
        }
      });

      test('should have valid category properties', () {
        for (final category in Category.predefinedCategories) {
          expect(category.name.isNotEmpty, true);
          expect(category.icon, isNotNull);
          expect(category.color, isNotNull);
        }
      });

      test('should handle custom category names', () {
        final customCategories = ['Food & Dining', 'Health & Medical', 'Travel'];
        for (final categoryName in customCategories) {
          final expense = validExpense.copyWith(category: categoryName);
          expect(expense.category, categoryName);
        }
      });
    });

    group('Currency Validation', () {
      test('should accept valid currency codes', () {
        final validCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR', 'EGP'];
        
        for (final currency in validCurrencies) {
          final expense = validExpense.copyWith(currency: currency);
          expect(expense.currency, currency);
          expect(expense.currency.length, 3);
        }
      });

      test('should handle currency code case sensitivity', () {
        final expense = validExpense.copyWith(currency: 'usd');
        expect(expense.currency, 'usd');
      });
    });

    group('Date Validation', () {
      test('should accept current date', () {
        final now = DateTime.now();
        final expense = validExpense.copyWith(date: now);
        expect(expense.date, now);
      });

      test('should accept past dates', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 30));
        final expense = validExpense.copyWith(date: pastDate);
        expect(expense.date, pastDate);
        expect(expense.date.isBefore(DateTime.now()), true);
      });

      test('should accept future dates', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        final expense = validExpense.copyWith(date: futureDate);
        expect(expense.date, futureDate);
      });

      test('should handle date precision', () {
        final specificDate = DateTime(2024, 1, 15, 14, 30, 45);
        final expense = validExpense.copyWith(date: specificDate);
        expect(expense.date, specificDate);
      });
    });

    group('Description Validation', () {
      test('should accept valid descriptions', () {
        final descriptions = [
          'Grocery shopping',
          'Gas for car',
          'Movie tickets',
          'Coffee with friends',
          'Rent payment',
        ];

        for (final description in descriptions) {
          final expense = validExpense.copyWith(description: description);
          expect(expense.description, description);
        }
      });

      test('should handle empty description', () {
        final expense = validExpense.copyWith(description: '');
        expect(expense.description, '');
      });

      test('should handle long descriptions', () {
        final longDescription = 'A' * 500;
        final expense = validExpense.copyWith(description: longDescription);
        expect(expense.description, longDescription);
        expect(expense.description?.length, 500);
      });

      test('should handle special characters in description', () {
        final specialDescription = 'Coffee @ Café! (€5.50) - 50% discount';
        final expense = validExpense.copyWith(description: specialDescription);
        expect(expense.description, specialDescription);
      });
    });

    group('Converted Amount Validation', () {
      test('should have valid converted amount', () {
        expect(validExpense.convertedAmount, 50.0);
        expect(validExpense.convertedAmount > 0, true);
      });

      test('should handle currency conversion ratios', () {
        final expense = validExpense.copyWith(
          amount: 100.0,
          currency: 'EUR',
          convertedAmount: 108.5, // EUR to USD conversion
        );
        expect(expense.convertedAmount, 108.5);
        expect(expense.convertedAmount > expense.amount, true);
      });
    });

    group('Receipt Path Validation', () {
      test('should handle valid receipt paths', () {
        final validPaths = [
          '/storage/receipts/receipt_001.jpg',
          'assets/receipts/grocery_receipt.png',
          'file:///data/receipts/gas_receipt.pdf',
        ];

        for (final path in validPaths) {
          final expense = validExpense.copyWith(receiptPath: path);
          expect(expense.receiptPath, path);
        }
      });

      test('should handle null receipt path', () {
        final expense = validExpense.copyWith(receiptPath: null);
        expect(expense.receiptPath, null);
      });
    });

    group('Expense Equality', () {
      test('should be equal when all properties match', () {
        final expense1 = Expense(
          id: '1',
          category: 'Groceries',
          amount: 50.0,
          currency: 'USD',
          convertedAmount: 50.0,
          date: DateTime(2024, 1, 15),
          description: 'Test',
        );

        final expense2 = Expense(
          id: '1',
          category: 'Groceries',
          amount: 50.0,
          currency: 'USD',
          convertedAmount: 50.0,
          date: DateTime(2024, 1, 15),
          description: 'Test',
        );

        expect(expense1, expense2);
      });

      test('should not be equal when properties differ', () {
        final expense1 = validExpense;
        final expense2 = validExpense.copyWith(amount: 100.0);

        expect(expense1 == expense2, false);
      });
    });

    group('Expense CopyWith', () {
      test('should create new instance with updated properties', () {
        final updatedExpense = validExpense.copyWith(
          amount: 75.0,
          description: 'Updated description',
        );

        expect(updatedExpense.amount, 75.0);
        expect(updatedExpense.description, 'Updated description');
        expect(updatedExpense.id, validExpense.id);
        expect(updatedExpense.category, validExpense.category);
      });

      test('should preserve original when no changes', () {
        final copiedExpense = validExpense.copyWith();
        expect(copiedExpense, validExpense);
      });
    });
  });
} 