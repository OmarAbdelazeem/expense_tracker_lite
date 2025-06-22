# Expense Tracker Lite - Project Structure

## Overview
This Flutter application follows a clean, modular architecture with reusable components and centralized styling. The project is organized to maximize code reusability and maintainability.

## Directory Structure

```
lib/
├── bloc/                     # BLoC state management
│   ├── expense_bloc.dart
│   ├── expense_event.dart
│   └── expense_state.dart
├── models/                   # Data models
│   ├── category.dart
│   ├── expense.dart
│   └── expense.g.dart
├── screens/                  # Screen widgets
│   ├── dashboard/           # Dashboard screen components
│   │   ├── dashboard_header_widget.dart
│   │   ├── balance_card_widget.dart
│   │   └── expenses_list_widget.dart
│   ├── dashboard_screen.dart
│   └── add_expense_screen.dart
├── services/                # Business logic services
│   ├── currency_service.dart
│   └── storage_service.dart
├── utils/                   # Utilities and constants
│   ├── app_colors.dart      # Centralized color definitions
│   ├── app_dimensions.dart  # Spacing and sizing constants
│   ├── app_text_styles.dart # Typography system
│   ├── sample_data.dart
│   └── utils.dart          # Export file
├── widgets/                 # Reusable components
│   ├── expense_item_widget.dart
│   ├── balance_item_widget.dart
│   ├── custom_action_button.dart
│   ├── custom_bottom_navigation.dart
│   ├── custom_text_widget.dart  # Centralized text component
│   └── widgets.dart        # Export file
├── examples/                # Usage examples and documentation
│   └── custom_text_examples.dart
└── main.dart
```

## Component System

### Reusable Widgets

#### `ExpenseItemWidget`
- **Purpose**: Display individual expense items in lists
- **Props**: 
  - `expense`: Expense data object
  - `onTap`: Optional tap callback
  - `onLongPress`: Optional long press callback
- **Features**: 
  - Automatic category icon and color
  - Consistent styling with shadows
  - Currency symbol formatting

#### `BalanceItemWidget`
- **Purpose**: Display income/expense balance items
- **Props**:
  - `icon`: IconData for the item
  - `label`: Display label
  - `amount`: Monetary amount
  - `color`: Text color
- **Features**: 
  - Consistent typography
  - Automatic number formatting

#### `CustomActionButton`
- **Purpose**: Reusable circular action button with shadows
- **Props**:
  - `onPressed`: Required callback function
  - `icon`: Button icon
  - `backgroundColor`: Optional background color
  - `iconColor`: Optional icon color
  - `size`: Optional button size
  - `shadows`: Optional custom shadows
- **Features**: 
  - Consistent shadow styling
  - Customizable appearance

#### `CustomBottomNavigation`
- **Purpose**: Bottom navigation bar with FAB integration
- **Props**:
  - `onAddPressed`: Callback for add button
- **Features**: 
  - Notched design for FAB
  - Consistent icon styling
  - Integrated action button

#### `CustomText`
- **Purpose**: Centralized text component with consistent styling
- **Props**:
  - `text`: Required text content
  - `variant`: Text style variant (enum)
  - `color`: Optional color override
  - `fontWeight`, `fontSize`, `letterSpacing`: Optional style overrides
  - `textAlign`, `maxLines`, `overflow`: Text display options
- **Features**: 
  - Predefined text variants for consistency
  - Convenience constructors (CustomText.h1, CustomText.bodyMedium, etc.)
  - Style inheritance with custom overrides
  - Type-safe text styling

### Screen Components

#### Dashboard Screen Components
The dashboard screen is broken down into smaller, manageable components:

- **`DashboardHeaderWidget`**: User profile, greeting, and filter dropdown
- **`BalanceCardWidget`**: Total balance display with income/expense breakdown
- **`ExpensesListWidget`**: Scrollable list of expense items with infinite scroll

### Design System

#### Colors (`AppColors`)
Centralized color definitions including:
- Primary colors and variants
- Background colors
- Text colors (primary, secondary, on-primary)
- Category-specific colors
- Status colors (success, error, warning, info)
- Shadow and border colors

#### Dimensions (`AppDimensions`)
Consistent spacing and sizing:
- Padding and margin scales
- Border radius values
- Icon sizes
- Button heights
- Component-specific dimensions
- Shadow properties

#### Typography (`AppTextStyles`)
Structured text style system:
- Heading styles (h1-h4)
- Body text variants
- Label styles
- Button text styles
- Specialized styles (balance amounts, section headers)
- On-primary text styles for colored backgrounds

## Architecture Benefits

### 1. Maintainability
- **Single Source of Truth**: Colors, dimensions, and text styles are defined once
- **Component Isolation**: Each component has a single responsibility
- **Clear Dependencies**: Easy to understand component relationships

### 2. Reusability
- **Widget Library**: Common UI patterns are abstracted into reusable widgets
- **Consistent Styling**: Design system ensures visual consistency
- **Modular Screens**: Screen components can be easily rearranged or reused

### 3. Scalability
- **Easy Extension**: New components follow established patterns
- **Theme Support**: Centralized styling enables easy theme switching
- **Screen Organization**: Large screens are broken into manageable pieces

### 4. Developer Experience
- **Import Convenience**: Export files reduce import statements
- **Type Safety**: Strongly typed component props
- **Documentation**: Clear component interfaces and purposes

## Usage Examples

### Using Centralized Colors
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello World',
    style: AppTextStyles.onPrimaryLarge,
  ),
)
```

### Using Reusable Components
```dart
ExpenseItemWidget(
  expense: myExpense,
  onTap: () => handleExpenseTap(myExpense),
)
```

### Using CustomText Widget
```dart
// Basic usage with variant
CustomText('Hello World', variant: TextVariant.bodyMedium)

// Convenience constructors
CustomText.h1('Main Heading')
CustomText.bodyLarge('Important content')
CustomText.onPrimary('Text on colored background')

// With customization
CustomText.bodyMedium(
  'Custom styled text',
  color: AppColors.error,
  fontWeight: FontWeight.bold,
)
```

### Consistent Spacing
```dart
Padding(
  padding: EdgeInsets.all(AppDimensions.paddingXL),
  child: MyWidget(),
)
```

## Best Practices

1. **Use the design system**: Always prefer `AppColors`, `AppDimensions`, and `CustomText` over hardcoded values
2. **Component first**: Check if a reusable component exists before creating custom UI
3. **Text consistency**: Always use `CustomText` instead of regular `Text` widgets for consistency
4. **Screen organization**: Break large screens into logical component files
5. **Import organization**: Use the export files (`utils.dart`, `widgets.dart`) for cleaner imports
6. **Consistent naming**: Follow established naming conventions for new components

This structure provides a solid foundation for scaling the application while maintaining code quality and consistency. 