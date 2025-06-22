import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class CurrencyService {
  // Mock exchange rates for demo purposes and fallback
  static const Map<String, double> _mockRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'CAD': 1.25,
    'AUD': 1.35,
    'CHF': 0.92,
    'CNY': 6.45,
    'INR': 74.5,
    'EGP': 30.9,
  };

  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR', 'EGP'
  ];

  /// Get exchange rate from one currency to another using real API
  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    try {
      // Try real API first (if API key is configured)
      if (ApiConfig.useRealApi) {
        if (ApiConfig.debugMode) {
          print('Using real Exchange Rate API for $fromCurrency to $toCurrency');
        }
        return await _getRealExchangeRate(fromCurrency, toCurrency);
      } else {
        if (ApiConfig.debugMode) {
          print('Using mock exchange rates for $fromCurrency to $toCurrency');
        }
        // Use mock data with slight variations for demo
        return _getMockExchangeRateWithVariation(fromCurrency, toCurrency);
      }
    } catch (e) {
      if (ApiConfig.debugMode) {
        print('Exchange rate API error: $e');
        print('Falling back to mock rates');
      }
      // Fallback to mock rates if API fails
      return _getMockExchangeRate(fromCurrency, toCurrency);
    }
  }

  /// Real API implementation using Exchange Rate API v6
  Future<double> _getRealExchangeRate(String fromCurrency, String toCurrency) async {
    try {
      // Use pair conversion endpoint for direct conversion
      final url = '${ApiConfig.exchangeRateBaseUrl}/${ApiConfig.exchangeRateApiKey}/pair/$fromCurrency/$toCurrency';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['result'] == 'success') {
          final rate = (data['conversion_rate'] as num).toDouble();
          if (ApiConfig.debugMode) {
            print('Real API rate $fromCurrency to $toCurrency: $rate');
          }
          return rate;
        } else {
          throw Exception('API returned error: ${data['error-type']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch real exchange rate: $e');
    }
  }

  /// Mock exchange rate with random variation for demo
  double _getMockExchangeRateWithVariation(String fromCurrency, String toCurrency) {
    final baseFromRate = _mockRates[fromCurrency] ?? 1.0;
    final baseToRate = _mockRates[toCurrency] ?? 1.0;
    
    // Add some random variation to simulate real market fluctuations
    final variation = 0.98 + (Random().nextDouble() * 0.04); // ±2% variation
    final rate = (baseToRate / baseFromRate) * variation;
    
    if (ApiConfig.debugMode) {
      print('Mock rate $fromCurrency to $toCurrency: $rate (with variation)');
    }
    
    return rate;
  }

  /// Basic mock exchange rate without variation
  double _getMockExchangeRate(String fromCurrency, String toCurrency) {
    final fromRate = _mockRates[fromCurrency] ?? 1.0;
    final toRate = _mockRates[toCurrency] ?? 1.0;
    return toRate / fromRate;
  }

  /// Convert amount to USD (used for storage normalization)
  Future<double> convertToUSD(double amount, String fromCurrency) async {
    if (fromCurrency == 'USD') return amount;
    
    final rate = await getExchangeRate(fromCurrency, 'USD');
    return amount * rate;
  }

  /// Convert amount from one currency to another
  Future<double> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    if (fromCurrency == toCurrency) return amount;
    
    final rate = await getExchangeRate(fromCurrency, toCurrency);
    return amount * rate;
  }

  /// Get all exchange rates for a base currency (useful for displaying multiple currencies)
  Future<Map<String, double>> getAllRatesForCurrency(String baseCurrency) async {
    try {
      if (ApiConfig.useRealApi) {
        return await _getRealAllRates(baseCurrency);
      } else {
        return _getMockAllRates(baseCurrency);
      }
    } catch (e) {
      if (ApiConfig.debugMode) {
        print('Error fetching all rates: $e');
      }
      return _getMockAllRates(baseCurrency);
    }
  }

  /// Real API implementation for getting all rates
  Future<Map<String, double>> _getRealAllRates(String baseCurrency) async {
    try {
      final url = '${ApiConfig.exchangeRateBaseUrl}/${ApiConfig.exchangeRateApiKey}/latest/$baseCurrency';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['result'] == 'success') {
          final rates = data['conversion_rates'] as Map<String, dynamic>;
          return rates.map((key, value) => MapEntry(key, (value as num).toDouble()));
        } else {
          throw Exception('API returned error: ${data['error-type']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch all rates: $e');
    }
  }

  /// Mock implementation for getting all rates
  Map<String, double> _getMockAllRates(String baseCurrency) {
    final baseRate = _mockRates[baseCurrency] ?? 1.0;
    return _mockRates.map((currency, rate) => 
      MapEntry(currency, rate / baseRate)
    );
  }

  String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'INR':
        return '₹';
      case 'EGP':
        return 'E£';
      default:
        return currency;
    }
  }

  /// Validate if currency code is supported
  bool isCurrencySupported(String currency) {
    return supportedCurrencies.contains(currency.toUpperCase());
  }

  /// Get currency name for display
  String getCurrencyName(String currency) {
    switch (currency) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'British Pound';
      case 'JPY':
        return 'Japanese Yen';
      case 'CAD':
        return 'Canadian Dollar';
      case 'AUD':
        return 'Australian Dollar';
      case 'CHF':
        return 'Swiss Franc';
      case 'CNY':
        return 'Chinese Yuan';
      case 'INR':
        return 'Indian Rupee';
      case 'EGP':
        return 'Egyptian Pound';
      default:
        return currency;
    }
  }
} 