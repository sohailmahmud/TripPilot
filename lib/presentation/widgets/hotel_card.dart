import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/travel_entities.dart';
import 'info_chip.dart';
import 'item_image_placeholder.dart';
import 'rating_display.dart';

/// Displays a hotel result card with details and amenities
class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onViewDetails;

  const HotelCard({
    super.key,
    required this.hotel,
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
                  imageUrl: hotel.imageUrl,
                  placeholderIcon: Icons.hotel,
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
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Rating
                      RatingDisplay(rating: hotel.rating),
                      const SizedBox(height: 8),
                      // Price per night
                      Row(
                        children: [
                          Text(
                            '\$${hotel.pricePerNight.toStringAsFixed(0)}/night',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
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
            if (hotel.description != null) ...[
              Text(
                hotel.description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            // Location and amenities chips
            Wrap(
              spacing: 8,
              children: [
                InfoChip.primary(
                  label: hotel.location.city.toString(),
                  icon: Icons.location_on,
                ),
                if (hotel.distance > 0)
                  InfoChip.secondary(
                    label: '${hotel.distance.toStringAsFixed(1)} km',
                    icon: Icons.directions_walk,
                  ),
                if (hotel.amenities.isNotEmpty)
                  InfoChip.gray(
                    label: '✨ ${hotel.amenities.length} amenities',
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
