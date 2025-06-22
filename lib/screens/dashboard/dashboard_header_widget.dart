import 'package:flutter/material.dart';
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
      height: AppDimensions.headerHeight,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusM),
          bottomRight: Radius.circular(AppDimensions.radiusM),
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(),
          const SizedBox(width: AppDimensions.paddingL),
          Expanded(child: _buildUserGreeting()),
          _buildFilterDropdown(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: AppDimensions.profileAvatarSize,
      height: AppDimensions.profileAvatarSize,
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
      child: const CircleAvatar(
        radius: 25,

        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.person,
          color: AppColors.textOnPrimary,
          size: AppDimensions.iconL,
        ),
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText('Good Morning', variant: TextVariant.onPrimarySmall),
        CustomText('Shihab Rahman', variant: TextVariant.onPrimaryLarge),
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
        items:
            ['This month', 'Last 7 Days'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
