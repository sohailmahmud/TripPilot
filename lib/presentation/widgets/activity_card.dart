import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/travel_entities.dart';
import 'info_chip.dart';
import 'item_image_placeholder.dart';
import 'rating_display.dart';

/// Displays an activity result card with details
class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onViewDetails;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image, title and rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                ItemImagePlaceholder(
                  imageUrl: activity.imageUrl,
                  placeholderIcon: Icons.local_activity,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 12),
                // Title and rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Rating
                      if (activity.rating != null)
                        RatingDisplay(rating: activity.rating ?? 0.0),
                      const SizedBox(height: 8),
                      // Price and duration
                      Row(
                        children: [
                          Text(
                            '\$${activity.price?.toStringAsFixed(0) ?? '0'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${activity.duration ?? 0}h',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            if (activity.description != null) ...[
              Text(
                activity.description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            // Category and location chips
            Wrap(
              spacing: 8,
              children: [
                InfoChip.primary(
                  label: activity.category,
                ),
                if (activity.location.city != null)
                  InfoChip.gray(
                    label: '📍 ${activity.location.city}',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // View details button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.info_outline),
                label: const Text('View Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
