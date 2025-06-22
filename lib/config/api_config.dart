/// API Configuration for the Expense Tracker App
/// 
/// To use real exchange rates:
/// 1. Sign up for a free account at https://www.exchangerate-api.com/
/// 2. Get your API key from the dashboard
/// 3. Replace the placeholder below with your actual API key
/// 4. The app will automatically switch from mock data to real API calls

class ApiConfig {
  /// Exchange Rate API Configuration
  /// Get your free API key from: https://www.exchangerate-api.com/
  static const String exchangeRateApiKey = '950012a5c7aaf21c9a8e1cb0';
  
  /// API Base URL for Exchange Rate API v6
  static const String exchangeRateBaseUrl = 'https://v6.exchangerate-api.com/v6';
  
  /// Request timeout in seconds
  static const int requestTimeoutSeconds = 10;
  
  /// Whether to use real API (true) or mock data (false)
  static bool get useRealApi => exchangeRateApiKey != 'YOUR-API-KEY' && exchangeRateApiKey.isNotEmpty;
  
  /// Debug mode for additional logging
  static const bool debugMode = true;
} 