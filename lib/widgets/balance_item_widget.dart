import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'custom_text_widget.dart';

class BalanceItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;

  const BalanceItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: AppDimensions.iconS,
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            CustomText(
              label,
              variant: TextVariant.onPrimaryMedium,
              color: color,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        CustomText(
          '\$${NumberFormat('#,##0.00').format(amount)}',
          variant: TextVariant.onPrimaryMedium,
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
} 