import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimensions.dart';
import '../../widgets/expense_item_widget.dart';
import '../../widgets/custom_text_widget.dart';
import '../../widgets/shimmer_widget.dart';

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
          SizedBox(height: 70.h),
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
          return _buildLoadingState();
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return _buildEmptyState();
          }
          
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            itemCount: state.expenses.length,
            itemBuilder: (context, index) {
              final expense = state.expenses[index];
              return ExpenseItemWidget(
                expense: expense,
                index: index,
                onTap: () {
                  // Handle expense tap
                },
                onLongPress: () {
                  // Handle expense long press
                },
              );
            },
          );
        } else if (state is ExpenseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                CustomText(
                  'Error: ${state.message}',
                  variant: TextVariant.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      itemCount: 5, // Show 5 skeleton items
      itemBuilder: (context, index) {
        return ShimmerWidget(
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: AppDimensions.shadowBlurHigh,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Skeleton category icon
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Skeleton category name
                          Container(
                            width: 80.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          // Skeleton amount
                          Container(
                            width: 60.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Skeleton "Manually" text
                          Container(
                            width: 50.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          // Skeleton date
                          Container(
                            width: 70.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16.h),
          CustomText(
            'No expenses yet',
            variant: TextVariant.h3,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 8.h),
          CustomText(
            'Tap the + button to add your first expense',
            variant: TextVariant.bodyMedium,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 