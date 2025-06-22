# Exchange Rate API Setup Guide

This guide explains how to set up real exchange rate data for the Expense Tracker app using the Exchange Rate API.

## 🚀 Quick Start

### Step 1: Get Your Free API Key

1. Visit [ExchangeRate-API.com](https://www.exchangerate-api.com/)
2. Click "Get Free Key" 
3. Sign up for a free account
4. Copy your API key from the dashboard

### Step 2: Configure the App

1. Open `lib/config/api_config.dart`
2. Replace `'YOUR-API-KEY'` with your actual API key:

```dart
static const String exchangeRateApiKey = 'your-actual-api-key-here';
```

### Step 3: That's It! 🎉

The app will automatically:
- ✅ Switch from mock data to real exchange rates
- ✅ Fetch live currency conversion rates
- ✅ Store both original and USD-converted amounts
- ✅ Display both amounts in the expense list

## 📊 Features

### Real-Time Exchange Rates
- Fetches current exchange rates from 170+ currencies
- Updates automatically when adding expenses
- Handles network errors gracefully with fallback to mock data

### Dual Currency Display
- Shows original amount in the selected currency
- Shows converted USD amount in parentheses
- Example: `- €85 ($92)` for a EUR expense

### Supported Currencies
- USD (US Dollar)
- EUR (Euro) 
- GBP (British Pound)
- JPY (Japanese Yen)
- CAD (Canadian Dollar)
- AUD (Australian Dollar)
- CHF (Swiss Franc)
- CNY (Chinese Yuan)
- INR (Indian Rupee)
- EGP (Egyptian Pound)

## 🔧 API Details

### Endpoints Used
- **Pair Conversion**: `GET /v6/{api_key}/pair/{from}/{to}`
- **Latest Rates**: `GET /v6/{api_key}/latest/{base_currency}`

### Rate Limits (Free Plan)
- 1,500 requests per month
- No credit card required
- Perfect for personal expense tracking

### Error Handling
- Network timeout: 10 seconds
- Automatic fallback to mock data
- Debug logging (can be disabled in `api_config.dart`)

## 🧪 Testing

### Mock Data Mode
If no API key is configured, the app uses mock exchange rates with:
- ±2% random variation to simulate market fluctuations
- Realistic exchange rates based on recent market data
- All currency conversion features work identically

### Debug Mode
Enable debug logging in `lib/config/api_config.dart`:
```dart
static const bool debugMode = true;
```

This will print:
- Which data source is being used (real API vs mock)
- Exchange rates being fetched
- API errors and fallback behavior

## 💡 Tips

1. **Free Plan is Sufficient**: 1,500 requests/month covers ~50 expenses/day
2. **Offline Support**: App works without internet using cached/mock rates
3. **Multi-Currency**: Add expenses in any supported currency
4. **Automatic Conversion**: All amounts stored in USD for consistent reporting

## 🔒 Security

- API key is stored in code (suitable for demo/personal use)
- For production apps, consider environment variables
- Free plan has no sensitive financial data access

## 📞 Support

- Exchange Rate API docs: https://www.exchangerate-api.com/docs
- API status page: https://status.exchangerate-api.com/
- Email support: contact@exchangerate-api.com

---

**Ready to track expenses with real exchange rates!** 🌍💰 