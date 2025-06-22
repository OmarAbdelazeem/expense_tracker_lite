import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_colors.dart';

enum TextVariant {
  // Headings
  h1,
  h2,
  h3,
  h4,
  
  // Body text
  bodyLarge,
  bodyMedium,
  bodySmall,
  
  // Labels
  labelLarge,
  labelMedium,
  labelSmall,
  
  // On primary (for colored backgrounds)
  onPrimaryLarge,
  onPrimaryMedium,
  onPrimarySmall,
  
  // Buttons
  buttonLarge,
  buttonMedium,
  
  // Specialized
  balanceAmount,
  sectionHeader,
}

class CustomText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? height;

  const CustomText(
    this.text, {
    super.key,
    this.variant = TextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  });

  // Convenience constructors for common use cases
  const CustomText.h1(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.h1;

  const CustomText.h2(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.h2;

  const CustomText.h3(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.h3;

  const CustomText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.bodyLarge;

  const CustomText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.bodyMedium;

  const CustomText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.bodySmall;

  const CustomText.labelMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.labelMedium;

  const CustomText.onPrimary(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.onPrimaryMedium;

  const CustomText.balance(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.balanceAmount;

  const CustomText.sectionHeader(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
  }) : variant = TextVariant.sectionHeader;

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = _getBaseStyle();
    
    // Apply custom overrides
    TextStyle finalStyle = baseStyle.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      decoration: decoration,
      height: height,
    );

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getBaseStyle() {
    switch (variant) {
      case TextVariant.h1:
        return AppTextStyles.h1;
      case TextVariant.h2:
        return AppTextStyles.h2;
      case TextVariant.h3:
        return AppTextStyles.h3;
      case TextVariant.h4:
        return AppTextStyles.h4;
      case TextVariant.bodyLarge:
        return AppTextStyles.bodyLarge;
      case TextVariant.bodyMedium:
        return AppTextStyles.bodyMedium;
      case TextVariant.bodySmall:
        return AppTextStyles.bodySmall;
      case TextVariant.labelLarge:
        return AppTextStyles.labelLarge;
      case TextVariant.labelMedium:
        return AppTextStyles.labelMedium;
      case TextVariant.labelSmall:
        return AppTextStyles.labelSmall;
      case TextVariant.onPrimaryLarge:
        return AppTextStyles.onPrimaryLarge;
      case TextVariant.onPrimaryMedium:
        return AppTextStyles.onPrimaryMedium;
      case TextVariant.onPrimarySmall:
        return AppTextStyles.onPrimarySmall;
      case TextVariant.buttonLarge:
        return AppTextStyles.buttonLarge;
      case TextVariant.buttonMedium:
        return AppTextStyles.buttonMedium;
      case TextVariant.balanceAmount:
        return AppTextStyles.balanceAmount;
      case TextVariant.sectionHeader:
        return AppTextStyles.sectionHeader;
    }
  }
} 