import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable info chip widget for displaying badges/tags
class InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const InfoChip({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.grey,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  /// Primary colored chip (primary light background)
  factory InfoChip.primary({
    required String label,
    IconData? icon,
  }) {
    return InfoChip(
      label: label,
      icon: icon,
      backgroundColor: AppColors.primaryLight.withOpacity(0.1),
      textColor: AppColors.primaryLight,
    );
  }

  /// Secondary colored chip (blue background)
  factory InfoChip.secondary({
    required String label,
    IconData? icon,
  }) {
    return InfoChip(
      label: label,
      icon: icon,
      backgroundColor: Colors.blue.withOpacity(0.15),
      textColor: Colors.blue,
    );
  }

  /// Gray colored chip
  factory InfoChip.gray({
    required String label,
    IconData? icon,
  }) {
    return InfoChip(
      label: label,
      icon: icon,
      backgroundColor: Colors.grey.withOpacity(0.2),
      textColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
