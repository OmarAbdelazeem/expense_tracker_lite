import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            4.horizontalSpace,
            CustomText(
              label,
              variant: TextVariant.onPrimaryMedium,
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        2.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            8.horizontalSpace,
            CustomText(
              '\$',
              variant: TextVariant.onPrimaryMedium,
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            4.horizontalSpace,
            CustomText(
              '${NumberFormat('#,##0.00').format(amount)}',
              variant: TextVariant.onPrimaryMedium,
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
