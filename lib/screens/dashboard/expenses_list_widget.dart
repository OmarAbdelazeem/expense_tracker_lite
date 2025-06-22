import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimensions.dart';
import '../../widgets/expense_item_widget.dart';
import '../../widgets/custom_text_widget.dart';

class ExpensesListWidget extends StatelessWidget {
  final ScrollController scrollController;

  const ExpensesListWidget({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: AppDimensions.shadowBlurXHigh,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          _buildSectionHeader(),
          Expanded(
            child: _buildExpensesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'Recent Expenses',
            variant: TextVariant.sectionHeader,
          ),
          TextButton(
            onPressed: () {
              // Handle see all
            },
            child: CustomText(
              'see all',
              variant: TextVariant.bodyMedium,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return Center(
              child: CustomText(
                'No expenses found',
                variant: TextVariant.bodyMedium,
                color: AppColors.textSecondary,
              ),
            );
          }
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
            itemCount: state.expenses.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.expenses.length) {
                return state.isLoadingMore
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.paddingL),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : const SizedBox();
              }
              return ExpenseItemWidget(
                expense: state.expenses[index],
                onTap: () {
                  // Handle expense item tap
                },
                onLongPress: () {
                  // Handle expense item long press
                },
              );
            },
          );
        } else if (state is ExpenseError) {
          return Center(
            child: CustomText(
              state.message,
              variant: TextVariant.bodyMedium,
              color: AppColors.error,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
} 