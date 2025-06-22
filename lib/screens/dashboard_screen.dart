import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../utils/app_colors.dart';
import 'add_expense_screen.dart';
import 'dashboard/dashboard_header_widget.dart';
import 'dashboard/balance_card_widget.dart';
import 'dashboard/expenses_list_widget.dart';
import '../widgets/custom_bottom_navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedFilter = 'This month';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (selectedFilter) {
      case 'This month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(
          now.year,
          now.month + 1,
          1,
        ).subtract(const Duration(days: 1));
        break;
      case 'Last 7 Days':
        startDate = now.subtract(const Duration(days: 7));
        endDate = now;
        break;
    }

    context.read<ExpenseBloc>().add(
      LoadExpenses(startDate: startDate, endDate: endDate),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ExpenseBloc>().add(
        LoadMoreExpenses(
          startDate: null,
          endDate: null,
        ),
      );
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
    });
    _loadInitialData();
  }

  Future<void> _handleAddExpense() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );
    if (result == true) {
      _loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style for blue background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Blue background
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(color: AppColors.primary),
          ),
          SafeArea(
            child: Stack(
              children: [
                // White background for lower section
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(color: AppColors.cardBackground),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DashboardHeaderWidget(
                      selectedFilter: selectedFilter,
                      onFilterChanged: _onFilterChanged,
                    ),
                    Expanded(
                      child: ExpensesListWidget(
                        scrollController: _scrollController,
                      ),
                    ),
                  ],
                ),
                // Positioned balance card
                const Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: BalanceCardWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        onAddPressed: _handleAddExpense,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
