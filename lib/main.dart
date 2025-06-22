import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/expense_bloc.dart';
import 'bloc/expense_event.dart';
import 'services/storage_service.dart';
import 'services/currency_service.dart';
import 'screens/dashboard_screen.dart';
import 'utils/sample_data.dart';
import 'utils/app_colors.dart';
import 'models/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService.init();
  
  // Add sample data if no expenses exist
  final storageService = StorageService();
  if (storageService.getAllExpenses().isEmpty) {
    await SampleData.addSampleExpenses((expense) async {
      await storageService.addExpense(expense);
    });
  }
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(
            storageService: StorageService(),
            currencyService: CurrencyService(),
          )..add(const LoadExpenses()),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker Lite',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
