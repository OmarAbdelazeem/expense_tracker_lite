import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'custom_action_button.dart';

class CustomBottomNavigation extends StatelessWidget {
  final VoidCallback onAddPressed;

  const CustomBottomNavigation({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      color: AppColors.cardBackground,
      elevation: 20,
      child: Container(
        height: 65.h,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, true),
            _buildNavItem(Icons.bar_chart, false),
            CustomActionButton(
              onPressed: onAddPressed,
              icon: Icons.add,
            ),
            _buildNavItem(Icons.credit_card, false),
            _buildNavItem(Icons.person, false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? AppColors.primary : AppColors.textSecondary,
        size: 28.sp,
      ),
      onPressed: () {},
    );
  }
} 