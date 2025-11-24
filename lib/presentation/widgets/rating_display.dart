import 'package:flutter/material.dart';

/// Rating display widget showing star and rating value
class RatingDisplay extends StatelessWidget {
  final double rating;
  final String? reviewCount;
  final double iconSize;
  final double fontSize;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 16,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: iconSize,
          color: Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          reviewCount != null
              ? '${rating.toStringAsFixed(1)} ($reviewCount reviews)'
              : '${rating.toStringAsFixed(1)} ★',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
