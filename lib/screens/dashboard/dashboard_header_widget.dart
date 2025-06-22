import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimensions.dart';
import '../../widgets/custom_text_widget.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const DashboardHeaderWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusM),
          bottomRight: Radius.circular(AppDimensions.radiusM),
        ),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  SizedBox(width: 16.w),
                  _buildUserGreeting(),
                ],
              ),
              _buildFilterDropdown(),
            ],
          ),
          // SizedBox(height: 20.h),
          // _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: 54.w,
      height: 54.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderMedium, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: AppDimensions.shadowBlurMedium,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 27.r,
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.person,
          color: AppColors.textOnPrimary,
          size: 28.sp,
        ),
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText('Good Morning', variant: TextVariant.onPrimarySmall),
        SizedBox(height: 4.h),
        CustomText('Shihab Rahman', variant: TextVariant.onPrimaryLarge,fontWeight: FontWeight.w500,),
      ],
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: DropdownButton<String>(
        value: selectedFilter,
        underline: const SizedBox(),
        icon: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
        ),
        items: ['This month', 'Last 7 Days'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 0,
              ),
              child: CustomText(value, variant: TextVariant.labelMedium),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onFilterChanged(value);
          }
        },
        dropdownColor: AppColors.cardBackground,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


}
