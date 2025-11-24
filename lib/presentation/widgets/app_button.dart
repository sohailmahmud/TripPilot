import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// Button size variants
enum ButtonSize {
  small(height: 36, padding: EdgeInsets.symmetric(horizontal: 16)),
  medium(height: 44, padding: EdgeInsets.symmetric(horizontal: 20)),
  large(height: 48, padding: EdgeInsets.symmetric(horizontal: 24));

  final double height;
  final EdgeInsets padding;

  const ButtonSize({required this.height, required this.padding});
}

/// Button style variants
enum AppButtonStyle {
  primary,
  secondary,
  success,
  warning,
  error,
  outline,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonSize size;
  final AppButtonStyle style;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final bool isIconLeading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.isIconLeading = true,
  });

  Color _getBackgroundColor() {
    if (!isEnabled || isLoading) {
      return Colors.grey[300] ?? Colors.grey;
    }

    switch (style) {
      case AppButtonStyle.primary:
        return AppColors.primaryAccentLight;
      case AppButtonStyle.secondary:
        return AppColors.secondaryLight;
      case AppButtonStyle.success:
        return AppColors.successLight;
      case AppButtonStyle.warning:
        return AppColors.warningLight;
      case AppButtonStyle.error:
        return AppColors.errorLight;
      case AppButtonStyle.outline:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (style == AppButtonStyle.outline) {
      return AppColors.primaryLight;
    }
    return Colors.white;
  }

  Color _getBorderColor() {
    if (style == AppButtonStyle.outline) {
      return AppColors.primaryLight;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isEnabled && !isLoading) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        minimumSize: Size(double.infinity, size.height),
        padding: size.padding,
        side: BorderSide(
          color: _getBorderColor(),
          width: 1.5,
        ),
        disabledBackgroundColor: Colors.grey[300] ?? Colors.grey,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && isIconLeading) ...[
                  Icon(icon, color: _getTextColor(), size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppFonts.labelLarge().copyWith(
                    color: _getTextColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (icon != null && !isIconLeading) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: _getTextColor(), size: 20),
                ],
              ],
            ),
    );
  }
}
