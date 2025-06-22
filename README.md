# Expense Tracker Lite

A lightweight expense tracking mobile application built with Flutter that works offline, integrates with currency conversion, supports pagination, and features a custom UI.

## Features

### 🏗️ Architecture & State Management
- **BLoC Pattern**: Uses `flutter_bloc` for state management across all features
- **Separation of Concerns**: Each feature has its own BLoC to manage state transitions and business logic
- **Reactive UI**: UI reacts to state changes using BlocBuilder and BlocListener

### 📱 Core Features

#### 1. Dashboard Screen
- User welcome message and profile image
- Displays total balance, income, and expenses
- Filter options (This Month, Last 7 Days)
- List of recent expenses with pagination
- Floating action button to add new expenses

#### 2. Add Expense Screen
- Category selection with predefined categories
- Amount input with currency selection
- Date picker for expense date
- Receipt upload functionality (camera/gallery)
- Category icon selection UI
- Currency dropdown with 10+ supported currencies

#### 3. Currency Conversion (API Integration)
- Automatic currency conversion to USD when saving expenses
- Stores both original amount and converted amount
- Mock API with realistic exchange rates and market fluctuations
- Support for 10+ currencies (USD, EUR, GBP, JPY, CAD, AUD, CHF, CNY, INR, EGP)

#### 4. Pagination
- Expense list paginated with 10 items per page
- Infinite scroll implementation
- Loading states and error handling
- Filter-aware pagination (maintains filters during pagination)

#### 5. Local Storage
- **Hive Database**: Platform-specific storage for offline functionality
- Data persistence across app sessions
- Fast local queries and data retrieval

#### 6. Expense Summary
- Total amount calculation in USD
- Filtered summaries by date range
- Real-time balance updates

## 🎨 Design

The app closely replicates the provided design mockups with:
- Modern card-based layout
- Gradient backgrounds
- Consistent typography and spacing
- Icon-based category system
- Clean, minimal interface

## 🛠️ Technical Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: flutter_bloc (BLoC pattern)
- **Local Storage**: Hive + Hive Flutter
- **HTTP Client**: http package for API calls
- **Image Handling**: image_picker for receipt uploads
- **Date Formatting**: intl package
- **Code Generation**: build_runner + hive_generator

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  http: ^1.1.0
  intl: ^0.19.0
  image_picker: ^1.0.4
  path_provider: ^2.1.1
  cached_network_image: ^3.3.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK 2.19.0 or higher
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker_lite
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

### Adding an Expense
1. Tap the floating action button (+) on the dashboard
2. Select a category from the dropdown or category icons
3. Enter the amount and select currency
4. Pick a date for the expense
5. Optionally upload a receipt image
6. Tap 'Save' to add the expense

### Viewing Expenses
- Dashboard shows recent expenses with pagination
- Use filter dropdown to view expenses by time period
- Scroll down to load more expenses automatically
- View total balance, income, and expenses at the top

### Currency Conversion
- All expenses are automatically converted to USD for consistent tracking
- Original currency and amount are preserved
- Exchange rates are simulated with realistic market variations

## 🏗️ Project Structure

```
lib/
├── bloc/                 # BLoC files (events, states, blocs)
├── models/              # Data models (Expense, Category)
├── screens/             # UI screens (Dashboard, Add Expense)
├── services/            # Business logic (Storage, Currency)
├── utils/               # Utilities and helpers
└── main.dart           # App entry point
```

## 🧪 Testing

The app includes comprehensive error handling and loading states:
- Network error handling for currency conversion
- Form validation for expense creation
- Empty states for expense lists
- Loading indicators during operations

## 🎯 Future Enhancements

- Export expenses to CSV/PDF
- Expense categories customization
- Budget tracking and alerts
- Expense analytics and charts
- Multi-language support
- Cloud sync functionality

## 📄 License

This project is created for demonstration purposes as part of a mobile engineering assessment.

---

Built with ❤️ using Flutter & BLoC
