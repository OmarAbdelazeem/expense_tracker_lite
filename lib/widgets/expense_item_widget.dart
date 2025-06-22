import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/currency_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_animations.dart';
import 'custom_text_widget.dart';

class ExpenseItemWidget extends StatefulWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int index;

  const ExpenseItemWidget({
    super.key,
    required this.expense,
    this.onTap,
    this.onLongPress,
    this.index = 0,
  });

  @override
  State<ExpenseItemWidget> createState() => _ExpenseItemWidgetState();
}

class _ExpenseItemWidgetState extends State<ExpenseItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    // Staggered animation delay based on index
    final delay = Duration(milliseconds: widget.index * 100);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        1.0,
        curve: AppAnimations.defaultCurve,
      ),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        1.0,
        curve: AppAnimations.smoothCurve,
      ),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        1.0,
        curve: AppAnimations.bounceCurve,
      ),
    ));

    // Start animation with delay
    Future.delayed(delay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = Category.getCategoryByName(widget.expense.category);
    final currencyService = CurrencyService();
    final currencySymbol = currencyService.getCurrencySymbol(widget.expense.currency);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
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
                                  widget.expense.category,
                                  variant: TextVariant.bodyLarge,
                                  fontWeight: FontWeight.w500,
                                ),
                                _buildAmountDisplay(),
                              ],
                            ),
                            _buildSubtitle(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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

  Widget _buildAmountDisplay() {
    final currencyService = CurrencyService();
    final originalCurrencySymbol =
        currencyService.getCurrencySymbol(widget.expense.currency);
    return Row(
      children: [
        CustomText(
          '- $originalCurrencySymbol${NumberFormat('#,##0').format(widget.expense.amount)}',
          variant: TextVariant.bodyLarge,
          fontWeight: FontWeight.w500,
        ),
        if (widget.expense.currency != "USD")
          CustomText(
            ' => (\$${NumberFormat('#,##0').format(widget.expense.convertedAmount)})',
            variant: TextVariant.bodySmall,
            color: AppColors.textSecondary,
          ),
      ],
    );
  }

  Widget _buildSubtitle() {
    // Format date to match screenshot: "Today 12:00 PM"
    final now = DateTime.now();
    final isToday = widget.expense.date.year == now.year &&
        widget.expense.date.month == now.month &&
        widget.expense.date.day == now.day;

    final dateText = isToday
        ? 'Today ${DateFormat('h:mm a').format(widget.expense.date)}'
        : DateFormat('MMM dd, yyyy h:mm a').format(widget.expense.date);

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
