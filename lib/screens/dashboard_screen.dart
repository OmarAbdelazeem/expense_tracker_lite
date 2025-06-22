import 'package:expense_tracker_lite/widgets/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import 'add_expense_screen.dart';
import 'dashboard/dashboard_header_widget.dart';
import 'dashboard/balance_card_widget.dart';
import 'dashboard/expenses_list_widget.dart';
import '../widgets/pdf_export_widget.dart';

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
      AppAnimations.slideUpTransition(const AddExpenseScreen()),
    );
    if (result == true) {
      _loadInitialData();
    }
  }

  Future<void> _handlePdfExport() async {
    final state = context.read<ExpenseBloc>().state;
    if (state is ExpenseLoaded) {
      // Calculate current date range based on selected filter
      final now = DateTime.now();
      DateTimeRange? dateRange;

      switch (selectedFilter) {
        case 'This month':
          dateRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: DateTime(now.year, now.month + 1, 1)
                .subtract(const Duration(days: 1)),
          );
          break;
        case 'Last 7 Days':
          dateRange = DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          );
          break;
      }

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: PdfExportWidget(
            expenses: state.expenses,
            dateRange: dateRange,
          ),
        ),
      );
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
            height: 0.6.sh,
            decoration: const BoxDecoration(color: AppColors.primary),
          ),
          SafeArea(
            child: Stack(
              children: [
                // White background for lower section
                Container(
                  height: 0.6.sh,
                  decoration:
                      const BoxDecoration(color: AppColors.cardBackground),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: DashboardHeaderWidget(
                        selectedFilter: selectedFilter,
                        onFilterChanged: _onFilterChanged,
                      ),
                    ),
                    Expanded(
                      child: ExpensesListWidget(
                        scrollController: _scrollController,
                      ),
                    ),
                  ],
                ),
                // Positioned balance card with responsive positioning
                Positioned(
                  top: 100.h,
                  left: 0,
                  right: 0,
                  child: const BalanceCardWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
          floatingActionButton: _buildPdfButton(),
      bottomNavigationBar: CustomBottomNavigation(
        onAddPressed: _handleAddExpense,
      ),
    );
  }

   Widget _buildPdfButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: ()=>_handlePdfExport(),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.primary,
        elevation: 0,
        heroTag: "pdf_export",
        child: Icon(
          Icons.picture_as_pdf,
          size: 28.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
