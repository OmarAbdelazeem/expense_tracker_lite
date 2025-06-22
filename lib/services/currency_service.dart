import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  
  // Mock exchange rates for demo purposes
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

  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      // For demo purposes, use mock data with slight variations
      final baseFromRate = _mockRates[fromCurrency] ?? 1.0;
      final baseToRate = _mockRates[toCurrency] ?? 1.0;
      
      // Add some random variation to simulate real market fluctuations
      final variation = 0.98 + (Random().nextDouble() * 0.04); // ±2% variation
      final rate = (baseToRate / baseFromRate) * variation;
      
      return rate;
    } catch (e) {
      // Fallback to mock rates if API fails
      return _getMockExchangeRate(fromCurrency, toCurrency);
    }
  }

  double _getMockExchangeRate(String fromCurrency, String toCurrency) {
    final fromRate = _mockRates[fromCurrency] ?? 1.0;
    final toRate = _mockRates[toCurrency] ?? 1.0;
    return toRate / fromRate;
  }

  Future<double> convertToUSD(double amount, String fromCurrency) async {
    if (fromCurrency == 'USD') return amount;
    
    final rate = await getExchangeRate(fromCurrency, 'USD');
    return amount * rate;
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

  // Real API implementation (commented for demo)
  /*
  Future<double> _getRealExchangeRate(String fromCurrency, String toCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$fromCurrency'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return (rates[toCurrency] as num).toDouble();
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }
  */
} 