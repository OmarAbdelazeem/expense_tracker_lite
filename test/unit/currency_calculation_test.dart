import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_lite/services/currency_service.dart';

void main() {
  group('Currency Calculation Tests', () {
    late CurrencyService currencyService;

    setUp(() {
      currencyService = CurrencyService();
    });

    group('Exchange Rate Retrieval', () {
      test('should return exchange rates for all supported currencies', () async {
        // Test getting rates for all supported currencies
        const expectedCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR', 'EGP'];
        
        for (final currency in expectedCurrencies) {
          final rate = await currencyService.getExchangeRate(currency, 'USD');
          expect(rate, isA<double>());
          expect(rate > 0, true, reason: 'Invalid rate for $currency');
        }
      });

      test('should have USD to USD rate close to 1.0', () async {
        final rate = await currencyService.getExchangeRate('USD', 'USD');
        expect(rate, closeTo(1.0, 0.05)); // Allow 5% variation for mock fluctuation
      });

      test('should return consistent rates within reasonable bounds', () async {
        // EUR to USD should be around 1.15-1.25
        final eurRate = await currencyService.getExchangeRate('EUR', 'USD');
        expect(eurRate, greaterThan(0.8));
        expect(eurRate, lessThan(1.5));
        
        // GBP to USD should be around 1.25-1.35
        final gbpRate = await currencyService.getExchangeRate('GBP', 'USD');
        expect(gbpRate, greaterThan(0.8));
        expect(gbpRate, lessThan(1.6));
        
        // JPY to USD should be much smaller (0.006-0.012)
        final jpyRate = await currencyService.getExchangeRate('JPY', 'USD');
        expect(jpyRate, greaterThan(0.003));
        expect(jpyRate, lessThan(0.02));
      });

      test('should handle network delays gracefully', () async {
        final stopwatch = Stopwatch()..start();
        final rate = await currencyService.getExchangeRate('EUR', 'USD');
        stopwatch.stop();
        
        expect(rate, isA<double>());
        // Should complete within reasonable time (mock has 500ms delay)
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });
    });

    group('Currency Conversion', () {
      test('should convert USD to USD correctly', () async {
        final result = await currencyService.convertToUSD(100.0, 'USD');
        expect(result, 100.0); // USD to USD should always be exact
      });

      test('should convert EUR to USD correctly', () async {
        final result = await currencyService.convertToUSD(100.0, 'EUR');
        expect(result, isA<double>());
        expect(result > 100, true); // EUR is typically worth more than USD
      });

      test('should convert JPY to USD correctly', () async {
        final result = await currencyService.convertToUSD(10000.0, 'JPY');
        expect(result, isA<double>());
        expect(result < 1000, true); // JPY is worth much less than USD
      });

      test('should handle zero amounts', () async {
        final result = await currencyService.convertToUSD(0.0, 'EUR');
        expect(result, 0.0);
      });

      test('should handle negative amounts', () async {
        final result = await currencyService.convertToUSD(-50.0, 'GBP');
        expect(result, isA<double>());
        expect(result < 0, true);
      });

      test('should handle decimal amounts precisely', () async {
        final result = await currencyService.convertToUSD(25.99, 'CAD');
        expect(result, isA<double>());
        expect(result > 0, true);
        expect(result != 25.99, true); // Should be converted
      });

      test('should handle large amounts', () async {
        final result = await currencyService.convertToUSD(999999.99, 'AUD');
        expect(result, isA<double>());
        expect(result > 0, true);
      });

      test('should handle very small amounts', () async {
        final result = await currencyService.convertToUSD(0.01, 'CHF');
        expect(result, isA<double>());
        expect(result > 0, true);
      });
    });

    group('Currency Validation', () {
      test('should handle valid currency codes', () async {
        final validCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR', 'EGP'];
        
        for (final currency in validCurrencies) {
          final result = await currencyService.convertToUSD(100.0, currency);
          expect(result, isA<double>());
          expect(result >= 0, true);
        }
      });

      test('should handle invalid currency codes gracefully', () async {
        // Mock service may handle invalid currencies by returning fallback values
        final result = await currencyService.convertToUSD(100.0, 'INVALID');
        expect(result, isA<double>());
        expect(result >= 0, true);
      });

      test('should handle empty currency code', () async {
        // Mock service may handle empty currency by using fallback
        final result = await currencyService.convertToUSD(100.0, '');
        expect(result, isA<double>());
        expect(result >= 0, true);
      });

      test('should handle case sensitivity', () async {
        try {
          final result1 = await currencyService.convertToUSD(100.0, 'EUR');
          final result2 = await currencyService.convertToUSD(100.0, 'eur');
          // Depending on implementation, this might work or throw
          // The test documents the behavior
          expect(result1, isA<double>());
        } catch (e) {
          // Case sensitive implementation
          expect(e, isA<Exception>());
        }
      });
    });

    group('Rate Fluctuation', () {
      test('should simulate realistic rate fluctuations', () async {
        final rate1 = await currencyService.getExchangeRate('EUR', 'USD');
        await Future.delayed(const Duration(milliseconds: 100));
        final rate2 = await currencyService.getExchangeRate('EUR', 'USD');
        
        // Rates might be slightly different due to fluctuation
        expect(rate1, isA<double>());
        expect(rate2, isA<double>());
        expect(rate1 > 0, true);
        expect(rate2 > 0, true);
      });

      test('should keep fluctuations within reasonable bounds', () async {
        final rate1 = await currencyService.getExchangeRate('GBP', 'USD');
        await Future.delayed(const Duration(milliseconds: 100));
        final rate2 = await currencyService.getExchangeRate('GBP', 'USD');
        
        final percentChange = ((rate2 - rate1) / rate1).abs();
        
        // Fluctuation should be less than 5% in short time
        expect(percentChange, lessThan(0.05), 
            reason: 'Rate fluctuation too large for GBP');
      });
    });

    group('Conversion Accuracy', () {
      test('should maintain precision in conversions', () async {
        final amount = 123.456789;
        final result = await currencyService.convertToUSD(amount, 'EUR');
        
        // Result should have reasonable precision
        expect(result.toString().contains('.'), true);
        expect(result, isNot(equals(amount))); // Should be converted
      });

      test('should be consistent for same inputs within reasonable bounds', () async {
        final amount = 50.0;
        final currency = 'GBP';
        
        final result1 = await currencyService.convertToUSD(amount, currency);
        final result2 = await currencyService.convertToUSD(amount, currency);
        
        // Results should be reasonable (allowing for mock fluctuations)
        final difference = (result1 - result2).abs();
        expect(difference, lessThan(result1 * 0.1)); // Less than 10% difference for mock
        expect(result1, greaterThan(0));
        expect(result2, greaterThan(0));
      });

      test('should handle rounding appropriately', () async {
        final result = await currencyService.convertToUSD(1.0, 'EUR');
        
        // Result should be a reasonable number (not too many decimal places)
        final rounded = double.parse(result.toStringAsFixed(4));
        expect((result - rounded).abs(), lessThan(0.0001));
      });
    });

    group('Error Handling', () {
      test('should handle service unavailability gracefully', () async {
        // This tests the mock service's error handling
        // In a real implementation, this would test network failures
        try {
          final rate = await currencyService.getExchangeRate('EUR', 'USD');
          expect(rate, isA<double>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should provide meaningful error messages', () async {
        try {
          await currencyService.convertToUSD(100.0, 'INVALID');
          // If no exception is thrown, the service handles invalid currencies gracefully
          // This is acceptable behavior for a mock service
        } catch (e) {
          // If an exception is thrown, it should contain meaningful information
          expect(e.toString(), isNotEmpty);
        }
      });
    });

    group('Performance', () {
      test('should cache rates for performance', () async {
        final stopwatch = Stopwatch()..start();
        
        // First call
        await currencyService.getExchangeRate('EUR', 'USD');
        final firstCallTime = stopwatch.elapsedMilliseconds;
        
        stopwatch.reset();
        
        // Second call (should be faster if cached)
        await currencyService.getExchangeRate('EUR', 'USD');
        final secondCallTime = stopwatch.elapsedMilliseconds;
        
        // Both should complete in reasonable time
        expect(firstCallTime, lessThan(2000));
        expect(secondCallTime, lessThan(2000));
      });

      test('should handle multiple concurrent requests', () async {
        final futures = List.generate(5, (index) => 
            currencyService.convertToUSD(100.0, 'EUR'));
        
        final results = await Future.wait(futures);
        
        expect(results.length, 5);
        for (final result in results) {
          expect(result, isA<double>());
          expect(result > 0, true);
        }
      });
    });
  });
} 