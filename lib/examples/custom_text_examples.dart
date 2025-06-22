import 'package:flutter/material.dart';
import '../widgets/custom_text_widget.dart';
import '../utils/app_colors.dart';

/// Example screen demonstrating all CustomText widget variants and usage patterns
class CustomTextExamples extends StatelessWidget {
  const CustomTextExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.h3('CustomText Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Examples
            _buildSection(
              'Heading Variants',
              [
                CustomText.h1('Heading 1'),
                CustomText.h2('Heading 2'),
                CustomText.h3('Heading 3'),
                CustomText('Heading 4', variant: TextVariant.h4),
              ],
            ),
            
            // Body Text Examples
            _buildSection(
              'Body Text Variants',
              [
                CustomText.bodyLarge('Large body text for important content'),
                CustomText.bodyMedium('Medium body text for regular content'),
                CustomText.bodySmall('Small body text for secondary information'),
              ],
            ),
            
            // Label Examples
            _buildSection(
              'Label Variants',
              [
                CustomText.labelMedium('Form Label'),
                CustomText('Small Label', variant: TextVariant.labelSmall),
                CustomText('Large Label', variant: TextVariant.labelLarge),
              ],
            ),
            
            // On Primary Examples (for colored backgrounds)
            _buildColoredSection(
              'On Primary Variants (for colored backgrounds)',
              [
                CustomText.onPrimary('Primary Large Text'),
                CustomText('Primary Medium Text', variant: TextVariant.onPrimaryMedium),
                CustomText('Primary Small Text', variant: TextVariant.onPrimarySmall),
              ],
            ),
            
            // Specialized Examples
            _buildSection(
              'Specialized Variants',
              [
                CustomText.balance('\$12,345.67'),
                CustomText.sectionHeader('Section Header'),
                CustomText('Button Text', variant: TextVariant.buttonLarge),
              ],
            ),
            
            // Customization Examples
            _buildSection(
              'Customization Examples',
              [
                CustomText(
                  'Custom Color Text',
                  variant: TextVariant.bodyLarge,
                  color: AppColors.error,
                ),
                CustomText(
                  'Custom Font Weight',
                  variant: TextVariant.bodyMedium,
                  fontWeight: FontWeight.w900,
                ),
                CustomText(
                  'Custom Font Size',
                  variant: TextVariant.bodyMedium,
                  fontSize: 24,
                ),
                CustomText(
                  'Custom Letter Spacing',
                  variant: TextVariant.bodyMedium,
                  letterSpacing: 2.0,
                ),
                CustomText(
                  'Centered Text',
                  variant: TextVariant.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  'This is a very long text that will be truncated with ellipsis when it exceeds the maximum number of lines allowed',
                  variant: TextVariant.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  'Underlined Text',
                  variant: TextVariant.bodyMedium,
                  decoration: TextDecoration.underline,
                ),
              ],
            ),
            
            // Usage Patterns
            _buildSection(
              'Common Usage Patterns',
              [
                // Using base constructor
                CustomText(
                  'Using base constructor',
                  variant: TextVariant.bodyMedium,
                  color: AppColors.primary,
                ),
                
                // Using convenience constructors
                CustomText.h2('Using convenience constructor'),
                
                // Combining with other widgets
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning),
                    const SizedBox(width: 8),
                    CustomText.bodyMedium('Text with icon'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        CustomText.h3(title),
        const SizedBox(height: 16),
        ...children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: child,
        )),
      ],
    );
  }

  Widget _buildColoredSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        CustomText.h3(title),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: child,
            )).toList(),
          ),
        ),
      ],
    );
  }
}

/// Quick reference for CustomText usage
class CustomTextUsageGuide {
  // Basic usage with variant
  static Widget basicUsage() {
    return CustomText(
      'Your text here',
      variant: TextVariant.bodyMedium,
    );
  }

  // Convenience constructors
  static Widget convenienceConstructors() {
    return Column(
      children: [
        CustomText.h1('Heading 1'),
        CustomText.h2('Heading 2'),
        CustomText.bodyLarge('Body large'),
        CustomText.bodyMedium('Body medium'),
        CustomText.labelMedium('Label'),
        CustomText.onPrimary('On primary background'),
        CustomText.balance('\$1,234.56'),
        CustomText.sectionHeader('Section'),
      ],
    );
  }

  // Customization examples
  static Widget customization() {
    return Column(
      children: [
        // Override color
        CustomText.bodyMedium(
          'Custom color',
          color: AppColors.error,
        ),
        
        // Override multiple properties
        CustomText(
          'Fully customized',
          variant: TextVariant.bodyMedium,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 1.5,
          textAlign: TextAlign.center,
        ),
        
        // Text overflow handling
        CustomText.bodyMedium(
          'Very long text that needs truncation...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
} 