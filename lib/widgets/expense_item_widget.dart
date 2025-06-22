import 'package:flutter/material.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
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
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.all(AppDimensions.paddingL),
        leading: _buildCategoryIcon(category),
        title: CustomText(
          expense.category,
          variant: TextVariant.bodyLarge,
        ),
        subtitle: _buildSubtitle(),
        trailing: CustomText(
          '- $currencySymbol${NumberFormat('#,##0').format(expense.amount)}',
          variant: TextVariant.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Category? category) {
    return Container(
      width: AppDimensions.categoryIconSize,
      height: AppDimensions.categoryIconSize,
      decoration: BoxDecoration(
        color: category?.color.withOpacity(0.12) ?? AppColors.textSecondary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: (category?.color ?? AppColors.textSecondary).withOpacity(0.15),
            blurRadius: AppDimensions.shadowBlurLight,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        category?.icon ?? Icons.receipt,
        color: category?.color ?? AppColors.textSecondary,
        size: 26,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.paddingXS),
        CustomText(
          'Manually',
          variant: TextVariant.bodySmall,
        ),
        const SizedBox(height: 2),
        CustomText(
          DateFormat('Today hh:mm a').format(expense.date),
          variant: TextVariant.bodySmall,
        ),
      ],
    );
  }
} 