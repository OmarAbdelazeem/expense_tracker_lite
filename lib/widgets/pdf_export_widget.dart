import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/pdf_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_animations.dart';
import '../widgets/custom_text_widget.dart';

class PdfExportWidget extends StatefulWidget {
  final List<Expense> expenses;
  final DateTimeRange? dateRange;

  const PdfExportWidget({
    super.key,
    required this.expenses,
    this.dateRange,
  });

  @override
  State<PdfExportWidget> createState() => _PdfExportWidgetState();
}

class _PdfExportWidgetState extends State<PdfExportWidget> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(height: 24.h),
          _buildExpenseSummary(),
          SizedBox(height: 24.h),
          _buildActionButtons(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.picture_as_pdf,
          color: AppColors.primary,
          size: 28.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomText(
            'Export PDF Report',
            variant: TextVariant.h3,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            color: AppColors.textSecondary,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseSummary() {
    final totalAmount = widget.expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.convertedAmount,
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'Transactions',
            widget.expenses.length.toString(),
            Icons.receipt_long,
          ),
          _buildSummaryItem(
            'Total Amount',
            '\$${NumberFormat('#,##0.00').format(totalAmount)}',
            Icons.attach_money,
          ),
          _buildSummaryItem(
            'Categories',
            widget.expenses.map((e) => e.category).toSet().length.toString(),
            Icons.category,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24.sp,
        ),
        SizedBox(height: 8.h),
        CustomText(
          value,
          variant: TextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 4.h),
        CustomText(
          label,
          variant: TextVariant.bodySmall,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          'Share PDF',
          Icons.share,
          AppColors.primary,
          _isGenerating ? null : _generateAndSharePdf,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Preview',
                Icons.visibility,
                AppColors.textSecondary,
                _isGenerating ? null : _previewPdf,
                isSecondary: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionButton(
                'Print',
                Icons.print,
                AppColors.textSecondary,
                _isGenerating ? null : _printPdf,
                isSecondary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onPressed, {
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSecondary ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color,
            width: isSecondary ? 1.5 : 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating && !isSecondary) ...[
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSecondary ? color : AppColors.textOnPrimary,
                  ),
                ),
              ),
            ] else ...[
              Icon(
                icon,
                color: isSecondary ? color : AppColors.textOnPrimary,
                size: 20.sp,
              ),
            ],
            SizedBox(width: 8.w),
            CustomText(
              _isGenerating && !isSecondary ? 'Generating...' : label,
              variant: TextVariant.bodyMedium,
              color: isSecondary ? color : AppColors.textOnPrimary,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final fileName = 'expense_report_${DateFormat('yyyy_MM_dd').format(DateTime.now())}.pdf';
      
      // Use the provided date range or create a default one covering all expenses
      final dateRange = widget.dateRange ?? _getDefaultDateRange();
      
      final pdfData = await PdfService.generateExpenseReport(
        expenses: widget.expenses,
        dateRange: dateRange,
        title: 'Expense Report',
      );

      await PdfService.sharePdf(pdfData, fileName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              'PDF report generated and ready to share!',
              variant: TextVariant.bodyMedium,
              color: AppColors.textOnPrimary,
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              'Error generating PDF: ${e.toString()}',
              variant: TextVariant.bodyMedium,
              color: AppColors.textOnPrimary,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _previewPdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Use the provided date range or create a default one covering all expenses
      final dateRange = widget.dateRange ?? _getDefaultDateRange();
      
      final pdfData = await PdfService.generateExpenseReport(
        expenses: widget.expenses,
        dateRange: dateRange,
        title: 'Expense Report',
      );

      await PdfService.printPdf(pdfData);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              'Error previewing PDF: ${e.toString()}',
              variant: TextVariant.bodyMedium,
              color: AppColors.textOnPrimary,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _printPdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Use the provided date range or create a default one covering all expenses
      final dateRange = widget.dateRange ?? _getDefaultDateRange();
      
      final pdfData = await PdfService.generateExpenseReport(
        expenses: widget.expenses,
        dateRange: dateRange,
        title: 'Expense Report',
      );

      await PdfService.printPdf(pdfData);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              'Error printing PDF: ${e.toString()}',
              variant: TextVariant.bodyMedium,
              color: AppColors.textOnPrimary,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  DateTimeRange _getDefaultDateRange() {
    if (widget.expenses.isEmpty) {
      return DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      );
    }

    // Find the earliest and latest expense dates
    final dates = widget.expenses.map((e) => e.date).toList()..sort();
    return DateTimeRange(
      start: dates.first,
      end: dates.last,
    );
  }
} 