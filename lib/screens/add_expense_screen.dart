import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/currency_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../widgets/custom_text_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final CurrencyService _currencyService = CurrencyService();
  final ImagePicker _imagePicker = ImagePicker();

  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _selectedCurrency = 'USD';
  File? _receiptImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _receiptImage = File(image.path);
        });
      }
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final convertedAmount =
          await _currencyService.convertToUSD(amount, _selectedCurrency);

      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory!.name,
        amount: amount,
        currency: _selectedCurrency,
        convertedAmount: convertedAmount,
        date: _selectedDate,
        receiptPath: _receiptImage?.path,
      );

      context.read<ExpenseBloc>().add(AddExpense(expense: expense));

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving expense: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CustomText(
          'Add Expense',
          variant: TextVariant.h4,
          color: AppColors.textPrimary,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySelection(),
              SizedBox(height: 24.h),
              _buildAmountField(),
              SizedBox(height: 24.h),
              _buildDateField(),
              SizedBox(height: 24.h),
              _buildReceiptUpload(),
              SizedBox(height: 24.h),
              _buildCategoryIcons(),
              SizedBox(height: 32.h),
              _buildSaveButton(),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Categories',
          variant: TextVariant.labelLarge,
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: _selectedCategory,
              hint: CustomText(
                'Entertainment',
                variant: TextVariant.bodyMedium,
                color: Colors.grey,
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: Category.predefinedCategories.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: CustomText(
                    category.name,
                    variant: TextVariant.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Amount',
          variant: TextVariant.labelLarge,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: '\$50,000',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  filled: true,
                  fillColor: const Color(0xFFF5F6FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    items: CurrencyService.supportedCurrencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: CustomText(
                          currency,
                          variant: TextVariant.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (currency) {
                      if (currency != null) {
                        setState(() {
                          _selectedCurrency = currency;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Date',
          variant: TextVariant.labelLarge,
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: _pickDate,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            suffixIcon:
                Icon(Icons.calendar_today, color: Colors.grey, size: 20.sp),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Attach Receipt',
          variant: TextVariant.labelLarge,
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_receiptImage != null) ...[
                  Image.file(
                    _receiptImage!,
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 12.w),
                  CustomText(
                    'Receipt attached',
                    variant: TextVariant.bodyMedium,
                  ),
                ] else ...[
                  CustomText(
                    'Upload image',
                    variant: TextVariant.bodyMedium,
                    color: Colors.grey,
                  ),
                  Icon(Icons.camera_alt, color: Colors.grey, size: 24.sp),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Categories',
          variant: TextVariant.labelLarge,
        ),
        SizedBox(height: 12.h),
        Wrap(
         
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            ...Category.predefinedCategories
                .map((category) => _buildCategoryIcon(category)),
            _buildAddCategoryIcon(),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(Category category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Column(
        children: [
          Container(
            width: 45.w,
            height: 45.h,
            decoration: BoxDecoration(
              color:
                  isSelected ? category.color : category.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category.icon,
              color: isSelected ? Colors.white : category.color,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 8.h),
          CustomText(
            category.name,
            variant: TextVariant.bodySmall,
            color: isSelected ? category.color : Colors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryIcon() {
    return Column(
      children: [
        Container(
          width: 45.w,
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Icon(
            Icons.add,
            color: Colors.grey,
            size: 28.sp,
          ),
        ),
        SizedBox(height: 8.h),
        CustomText(
          'Add Category',
          variant: TextVariant.bodySmall,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1d55f3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : CustomText(
                'Save',
                variant: TextVariant.buttonLarge,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
      ),
    );
  }
}
