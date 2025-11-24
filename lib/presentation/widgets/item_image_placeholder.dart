import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Image or placeholder widget for displaying item images
class ItemImagePlaceholder extends StatelessWidget {
  final String? imageUrl;
  final IconData placeholderIcon;
  final double width;
  final double height;
  final BoxFit fit;

  const ItemImagePlaceholder({
    super.key,
    required this.imageUrl,
    required this.placeholderIcon,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidImageUrl =
        imageUrl != null && imageUrl!.isNotEmpty && imageUrl!.startsWith('http');

    if (!hasValidImageUrl) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primaryLight.withOpacity(0.1),
      ),
      child: Icon(
        placeholderIcon,
        size: 40,
        color: AppColors.primaryLight,
      ),
    );
  }
}
