import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimensions.dart';
import '../../widgets/balance_item_widget.dart';
import '../../widgets/custom_text_widget.dart';

class BalanceCardWidget extends StatelessWidget {
  const BalanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        double totalExpenses = 0;
        double totalIncome = 10840.00; // Mock income

        if (state is ExpenseLoaded) {
          totalExpenses = state.totalAmount;
        }

        double totalBalance = totalIncome - totalExpenses;

        return Container(
          height: AppDimensions.balanceCardHeight,
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(
              color: AppColors.borderMedium,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark,
                blurRadius: AppDimensions.shadowBlurHigh,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.borderLight,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              _buildMoreOptionsButton(),
              _buildBalanceContent(totalBalance, totalIncome, totalExpenses),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreOptionsButton() {
    return const Positioned(
      top: AppDimensions.paddingL,
      right: AppDimensions.paddingL,
      child: Icon(
        Icons.more_horiz,
        color: AppColors.textOnPrimary,
        size: AppDimensions.iconL,
      ),
    );
  }

  Widget _buildBalanceContent(double totalBalance, double totalIncome, double totalExpenses) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceHeader(),
          const SizedBox(height: AppDimensions.paddingS),
          _buildBalanceAmount(totalBalance),
          const SizedBox(height: AppDimensions.paddingXXL),
          _buildBalanceItems(totalIncome, totalExpenses),
        ],
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Row(
      children: [
        CustomText(
          'Total Balance',
          variant: TextVariant.onPrimaryMedium,
        ),
        const SizedBox(width: AppDimensions.paddingS),
        const Icon(
          Icons.keyboard_arrow_up,
          color: AppColors.textOnPrimary,
          size: AppDimensions.iconS,
        ),
      ],
    );
  }

  Widget _buildBalanceAmount(double totalBalance) {
    return CustomText(
      '\$${NumberFormat('#,##0.00').format(totalBalance)}',
      variant: TextVariant.balanceAmount,
    );
  }

  Widget _buildBalanceItems(double totalIncome, double totalExpenses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BalanceItemWidget(
          icon: Icons.arrow_downward,
          label: 'Income',
          amount: totalIncome,
          color: AppColors.textOnPrimary,
        ),
        BalanceItemWidget(
          icon: Icons.arrow_upward,
          label: 'Expenses',
          amount: totalExpenses,
          color: AppColors.textOnPrimary,
        ),
      ],
    );
  }
} 