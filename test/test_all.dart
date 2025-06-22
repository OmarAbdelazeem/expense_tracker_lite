import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/expense_validation_test.dart' as expense_validation_tests;
import 'unit/currency_calculation_test.dart' as currency_calculation_tests;

void main() {
  group('All Tests', () {
    group('Unit Tests', () {
      expense_validation_tests.main();
      currency_calculation_tests.main();
    });
  });
} 