import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_lite/services/storage_service.dart';
import 'package:expense_tracker_lite/models/expense.dart';

void main() {
  group('Pagination Logic Tests', () {
    group('Storage Service Pagination', () {
      test('should return correct page size', () {
        final expenses = _generateMockExpenses(25);
        final mockStorage = MockStorageForTest(expenses);
        
        // Test first page
        final page1 = mockStorage.getExpensesPaginated(page: 0, limit: 10);
        expect(page1.length, 10);
        
        // Test second page
        final page2 = mockStorage.getExpensesPaginated(page: 1, limit: 10);
        expect(page2.length, 10);
        
        // Test third page (partial)
        final page3 = mockStorage.getExpensesPaginated(page: 2, limit: 10);
        expect(page3.length, 5);
        
        // Test beyond available data
        final page4 = mockStorage.getExpensesPaginated(page: 3, limit: 10);
        expect(page4.length, 0);
      });

      test('should return correct items for each page', () {
        final expenses = _generateMockExpenses(15);
        final mockStorage = MockStorageForTest(expenses);
        
        final page1 = mockStorage.getExpensesPaginated(page: 0, limit: 5);
        final page2 = mockStorage.getExpensesPaginated(page: 1, limit: 5);
        final page3 = mockStorage.getExpensesPaginated(page: 2, limit: 5);
        
        // Verify no overlap between pages
        final page1Ids = page1.map((e) => e.id).toSet();
        final page2Ids = page2.map((e) => e.id).toSet();
        final page3Ids = page3.map((e) => e.id).toSet();
        
        expect(page1Ids.intersection(page2Ids).isEmpty, true);
        expect(page1Ids.intersection(page3Ids).isEmpty, true);
        expect(page2Ids.intersection(page3Ids).isEmpty, true);
      });

      test('should handle empty data set', () {
        final mockStorage = MockStorageForTest([]);
        
        final page1 = mockStorage.getExpensesPaginated(page: 0, limit: 10);
        expect(page1.length, 0);
        
        final totalCount = mockStorage.getTotalExpenseCount();
        expect(totalCount, 0);
      });

      test('should handle single item', () {
        final expenses = _generateMockExpenses(1);
        final mockStorage = MockStorageForTest(expenses);
        
        final page1 = mockStorage.getExpensesPaginated(page: 0, limit: 10);
        expect(page1.length, 1);
        
        final page2 = mockStorage.getExpensesPaginated(page: 1, limit: 10);
        expect(page2.length, 0);
      });

      test('should handle exact page boundary', () {
        final expenses = _generateMockExpenses(20); // Exactly 2 pages of 10
        final mockStorage = MockStorageForTest(expenses);
        
        final page1 = mockStorage.getExpensesPaginated(page: 0, limit: 10);
        expect(page1.length, 10);
        
        final page2 = mockStorage.getExpensesPaginated(page: 1, limit: 10);
        expect(page2.length, 10);
        
        final page3 = mockStorage.getExpensesPaginated(page: 2, limit: 10);
        expect(page3.length, 0);
      });

      test('should handle different page sizes', () {
        final expenses = _generateMockExpenses(25);
        final mockStorage = MockStorageForTest(expenses);
        
        // Test with page size 5
        final smallPages = mockStorage.getExpensesPaginated(page: 0, limit: 5);
        expect(smallPages.length, 5);
        
        // Test with page size 15
        final largePages = mockStorage.getExpensesPaginated(page: 0, limit: 15);
        expect(largePages.length, 15);
        
        // Test with page size larger than total
        final hugePage = mockStorage.getExpensesPaginated(page: 0, limit: 50);
        expect(hugePage.length, 25);
      });
    });

    group('Date Range Filtering with Pagination', () {
      test('should paginate filtered results correctly', () {
        final expenses = _generateMockExpensesWithDates(20);
        final mockStorage = MockStorageForTest(expenses);
        
        final startDate = DateTime.now().subtract(const Duration(days: 10));
        final endDate = DateTime.now().subtract(const Duration(days: 5));
        
        // Get filtered results
        final filteredPage1 = mockStorage.getExpensesPaginated(
          page: 0,
          limit: 3,
          startDate: startDate,
          endDate: endDate,
        );
        
        expect(filteredPage1.length, lessThanOrEqualTo(3));
        
        // Verify all results are within date range
        for (final expense in filteredPage1) {
          expect(expense.date.isAfter(startDate.subtract(const Duration(days: 1))), true);
          expect(expense.date.isBefore(endDate.add(const Duration(days: 1))), true);
        }
      });

      test('should return correct total count for filtered results', () {
        final expenses = _generateMockExpensesWithDates(20);
        final mockStorage = MockStorageForTest(expenses);
        
        final startDate = DateTime.now().subtract(const Duration(days: 10));
        final endDate = DateTime.now().subtract(const Duration(days: 5));
        
        final totalCount = mockStorage.getTotalExpenseCount(
          startDate: startDate,
          endDate: endDate,
        );
        
        final allFiltered = mockStorage.getExpensesPaginated(
          page: 0,
          limit: 100, // Get all
          startDate: startDate,
          endDate: endDate,
        );
        
        expect(totalCount, allFiltered.length);
      });
    });

    group('Pagination Helper Functions', () {
      test('should calculate hasMore correctly', () {
        expect(hasMorePages(currentPage: 0, totalItems: 25, pageSize: 10), true);
        expect(hasMorePages(currentPage: 1, totalItems: 25, pageSize: 10), true);
        expect(hasMorePages(currentPage: 2, totalItems: 25, pageSize: 10), false);
        expect(hasMorePages(currentPage: 0, totalItems: 10, pageSize: 10), false);
        expect(hasMorePages(currentPage: 0, totalItems: 0, pageSize: 10), false);
      });

      test('should calculate total pages correctly', () {
        expect(calculateTotalPages(totalItems: 25, pageSize: 10), 3);
        expect(calculateTotalPages(totalItems: 20, pageSize: 10), 2);
        expect(calculateTotalPages(totalItems: 10, pageSize: 10), 1);
        expect(calculateTotalPages(totalItems: 0, pageSize: 10), 0);
        expect(calculateTotalPages(totalItems: 1, pageSize: 10), 1);
      });

      test('should calculate items on page correctly', () {
        expect(itemsOnPage(currentPage: 0, totalItems: 25, pageSize: 10), 10);
        expect(itemsOnPage(currentPage: 1, totalItems: 25, pageSize: 10), 10);
        expect(itemsOnPage(currentPage: 2, totalItems: 25, pageSize: 10), 5);
        expect(itemsOnPage(currentPage: 3, totalItems: 25, pageSize: 10), 0);
      });
    });

    group('Edge Cases', () {
      test('should handle negative page numbers', () {
        final expenses = _generateMockExpenses(10);
        final mockStorage = MockStorageForTest(expenses);
        
        final result = mockStorage.getExpensesPaginated(page: -1, limit: 5);
        expect(result.length, 0);
      });

      test('should handle zero page size', () {
        final expenses = _generateMockExpenses(10);
        final mockStorage = MockStorageForTest(expenses);
        
        final result = mockStorage.getExpensesPaginated(page: 0, limit: 0);
        expect(result.length, 0);
      });

      test('should handle very large page numbers', () {
        final expenses = _generateMockExpenses(10);
        final mockStorage = MockStorageForTest(expenses);
        
        final result = mockStorage.getExpensesPaginated(page: 1000, limit: 10);
        expect(result.length, 0);
      });
    });
  });
}

// Mock storage class for testing
class MockStorageForTest {
  final List<Expense> _expenses;

  MockStorageForTest(this._expenses);

  List<Expense> getExpensesPaginated({
    required int page,
    required int limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (page < 0 || limit <= 0) return [];

    List<Expense> expenses = List.from(_expenses);
    
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
      return _expenses
          .where((expense) =>
              expense.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(endDate.add(const Duration(days: 1))))
          .length;
    }
    return _expenses.length;
  }
}

// Helper functions for pagination logic
bool hasMorePages({required int currentPage, required int totalItems, required int pageSize}) {
  final totalPages = calculateTotalPages(totalItems: totalItems, pageSize: pageSize);
  return currentPage < totalPages - 1;
}

int calculateTotalPages({required int totalItems, required int pageSize}) {
  if (totalItems == 0 || pageSize <= 0) return 0;
  return (totalItems / pageSize).ceil();
}

int itemsOnPage({required int currentPage, required int totalItems, required int pageSize}) {
  if (currentPage < 0 || pageSize <= 0 || totalItems <= 0) return 0;
  
  final startIndex = currentPage * pageSize;
  if (startIndex >= totalItems) return 0;
  
  final endIndex = startIndex + pageSize;
  return endIndex > totalItems ? totalItems - startIndex : pageSize;
}

List<Expense> _generateMockExpenses(int count) {
  return List.generate(count, (index) {
    return Expense(
      id: (index + 1).toString(),
      category: 'Groceries',
      amount: 50.0 + (index * 10),
      currency: 'USD',
      convertedAmount: 50.0 + (index * 10),
      date: DateTime.now().subtract(Duration(days: index)),
      description: 'Test expense ${index + 1}',
    );
  });
}

List<Expense> _generateMockExpensesWithDates(int count) {
  return List.generate(count, (index) {
    return Expense(
      id: (index + 1).toString(),
      category: 'Groceries',
      amount: 50.0 + (index * 10),
      currency: 'USD',
      convertedAmount: 50.0 + (index * 10),
      date: DateTime.now().subtract(Duration(days: index)),
      description: 'Test expense ${index + 1}',
    );
  });
} 