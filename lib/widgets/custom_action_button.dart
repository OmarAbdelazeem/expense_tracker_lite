import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final List<BoxShadow>? shadows;

  const CustomActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: shadows ?? [
          BoxShadow(
            color: AppColors.shadowPrimary,
            blurRadius: AppDimensions.shadowBlurHigh,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 0,
        fillColor: backgroundColor ?? AppColors.primary,
        padding: EdgeInsets.all(size ?? 15.0),
        shape: const CircleBorder(),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.textOnPrimary,
          size: AppDimensions.iconL,
        ),
      ),
    );
  }
} 