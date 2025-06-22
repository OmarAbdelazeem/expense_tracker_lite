import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_animations.dart';

class CustomActionButton extends StatefulWidget {
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
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: widget.shadows ?? [
                  BoxShadow(
                    color: AppColors.shadowPrimary,
                    blurRadius: AppDimensions.shadowBlurHigh,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: RawMaterialButton(
                onPressed: widget.onPressed,
                elevation: 0,
                fillColor: widget.backgroundColor ?? AppColors.primary,
                padding: EdgeInsets.all(widget.size ?? 15.0),
                shape: const CircleBorder(),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor ?? AppColors.textOnPrimary,
                  size: AppDimensions.iconL,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 