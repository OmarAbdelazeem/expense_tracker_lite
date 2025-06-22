import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/currency_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'custom_text_widget.dart';

class ExpenseItemWidget extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ExpenseItemWidget({
    super.key,
    required this.expense,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final category = Category.getCategoryByName(expense.category);
    final currencyService = CurrencyService();
    final currencySymbol = currencyService.getCurrencySymbol(expense.currency);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurHigh,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurLight,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            _buildCategoryIcon(category),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        expense.category,
                        variant: TextVariant.bodyLarge,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        '- $currencySymbol${NumberFormat('#,##0').format(expense.amount)}',
                        variant: TextVariant.bodyLarge,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  _buildSubtitle(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Category? category) {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: category?.color.withOpacity(0.12) ??
            AppColors.textSecondary.withOpacity(0.12),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                (category?.color ?? AppColors.textSecondary).withOpacity(0.15),
            blurRadius: AppDimensions.shadowBlurLight,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        category?.icon ?? Icons.receipt,
        color: category?.color ?? AppColors.textSecondary,
        size: 26.sp,
      ),
    );
  }

  Widget _buildSubtitle() {
    // Format date to match screenshot: "Today 12:00 PM"
    final now = DateTime.now();
    final isToday = expense.date.year == now.year && 
                   expense.date.month == now.month && 
                   expense.date.day == now.day;
    
    final dateText = isToday 
        ? 'Today ${DateFormat('h:mm a').format(expense.date)}'
        : DateFormat('MMM dd, yyyy h:mm a').format(expense.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              'Manually',
              variant: TextVariant.bodySmall,
            ),
        CustomText(
          dateText,
          variant: TextVariant.bodySmall,
        ),
          ],
        ),
      
      ],
    );
  }
}
