import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/currency_service.dart';

class PdfService {
  static const PdfColor primaryColor = PdfColor.fromInt(0xFF2E7D32);
  static const PdfColor secondaryColor = PdfColor.fromInt(0xFF4CAF50);
  static const PdfColor lightGray = PdfColor.fromInt(0xFFF5F5F5);
  static const PdfColor darkGray = PdfColor.fromInt(0xFF757575);
  static const PdfColor lightWhite = PdfColor.fromInt(0xFFE0E0E0);

  /// Generate expense report PDF
  static Future<Uint8List> generateExpenseReport({
    required List<Expense> expenses,
    required DateTimeRange dateRange,
    String title = 'Expense Report',
  }) async {
    final pdf = pw.Document();
    final currencyService = CurrencyService();

    // Calculate summary data
    final totalAmount = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.convertedAmount,
    );

    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0.0) + expense.convertedAmount;
    }

    // Sort expenses by date (newest first)
    final sortedExpenses = List<Expense>.from(expenses)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Load font for better text rendering
    final fontData = await rootBundle.load('assets/fonts/Poppins/Poppins-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load('assets/fonts/Poppins/Poppins-Bold.ttf');
    final boldTtf = pw.Font.ttf(boldFontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(title, dateRange, ttf, boldTtf),
            pw.SizedBox(height: 20),
            _buildSummarySection(totalAmount, expenses.length, ttf, boldTtf),
            pw.SizedBox(height: 20),
            _buildCategoryBreakdown(categoryTotals, totalAmount, ttf, boldTtf),
            pw.SizedBox(height: 20),
            _buildExpensesList(sortedExpenses, currencyService, ttf, boldTtf),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Build PDF header
  static pw.Widget _buildHeader(
    String title,
    DateTimeRange dateRange,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: primaryColor,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 24,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Expense Tracker Lite',
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 12,
                  color: lightWhite,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Period',
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 10,
                  color: lightWhite,
                ),
              ),
              pw.Text(
                '${DateFormat('MMM dd, yyyy').format(dateRange.start)} - ${DateFormat('MMM dd, yyyy').format(dateRange.end)}',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 10,
                  color: lightWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build summary section
  static pw.Widget _buildSummarySection(
    double totalAmount,
    int expenseCount,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: lightGray,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: darkGray, width: 0.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'Total Expenses',
            '\$${NumberFormat('#,##0.00').format(totalAmount)}',
            regularFont,
            boldFont,
          ),
          _buildSummaryItem(
            'Number of Transactions',
            expenseCount.toString(),
            regularFont,
            boldFont,
          ),
          _buildSummaryItem(
            'Average per Transaction',
            '\$${NumberFormat('#,##0.00').format(expenseCount > 0 ? totalAmount / expenseCount : 0)}',
            regularFont,
            boldFont,
          ),
        ],
      ),
    );
  }

  /// Build summary item
  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: regularFont,
            fontSize: 10,
            color: darkGray,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  /// Build category breakdown
  static pw.Widget _buildCategoryBreakdown(
    Map<String, double> categoryTotals,
    double totalAmount,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Expenses by Category',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: darkGray, width: 0.5),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Table(
            border: pw.TableBorder.all(color: darkGray, width: 0.5),
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: lightGray),
                children: [
                  _buildTableCell('Category', boldFont, isHeader: true),
                  _buildTableCell('Amount', boldFont, isHeader: true),
                  _buildTableCell('Percentage', boldFont, isHeader: true),
                ],
              ),
              // Data rows
              ...sortedCategories.map((entry) {
                final percentage = totalAmount > 0 ? (entry.value / totalAmount * 100) : 0;
                return pw.TableRow(
                  children: [
                    _buildTableCell(entry.key, regularFont),
                    _buildTableCell('\$${NumberFormat('#,##0.00').format(entry.value)}', regularFont),
                    _buildTableCell('${percentage.toStringAsFixed(1)}%', regularFont),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  /// Build table cell
  static pw.Widget _buildTableCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: isHeader ? 11 : 10,
          color: isHeader ? primaryColor : PdfColors.black,
        ),
      ),
    );
  }

  /// Build expenses list
  static pw.Widget _buildExpensesList(
    List<Expense> expenses,
    CurrencyService currencyService,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detailed Transactions',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 16,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: darkGray, width: 0.5),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Table(
            border: pw.TableBorder.all(color: darkGray, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(80),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FixedColumnWidth(80),
              4: const pw.FlexColumnWidth(1),
            },
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: lightGray),
                children: [
                  _buildTableCell('Date', boldFont, isHeader: true),
                  _buildTableCell('Description', boldFont, isHeader: true),
                  _buildTableCell('Category', boldFont, isHeader: true),
                  _buildTableCell('Original', boldFont, isHeader: true),
                  _buildTableCell('USD Amount', boldFont, isHeader: true),
                ],
              ),
              // Data rows
              ...expenses.map((expense) {
                final currencySymbol = currencyService.getCurrencySymbol(expense.currency);
                final description = expense.description?.isNotEmpty == true 
                    ? expense.description! 
                    : expense.category;
                return pw.TableRow(
                  children: [
                    _buildTableCell(DateFormat('MM/dd/yy').format(expense.date), regularFont),
                    _buildTableCell(description, regularFont),
                    _buildTableCell(expense.category, regularFont),
                    _buildTableCell('$currencySymbol${NumberFormat('#,##0').format(expense.amount)}', regularFont),
                    _buildTableCell('\$${NumberFormat('#,##0.00').format(expense.convertedAmount)}', regularFont),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  /// Share PDF file
  static Future<void> sharePdf(Uint8List pdfData, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfData);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Expense Report - $fileName',
      subject: 'Expense Report',
    );
  }

  /// Print PDF
  static Future<void> printPdf(Uint8List pdfData) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  /// Save PDF to device
  static Future<String> savePdfToDevice(Uint8List pdfData, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfData);
    return file.path;
  }
} 