import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String contact;
  final String eventDate;
  final String? imageUrl;
  final double? cardWidth; // Only for card width control

  // Hardcoded image dimensions (adjust as needed)
  static const double imageHeight = 120;
  static const double imageWidth = 90; // Full card width

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.contact,
    required this.eventDate,
    this.imageUrl,
    this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth ?? double.infinity,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image with FIXED dimensions
            if (imageUrl != null)
              SizedBox(
                height: imageHeight, // Hardcoded height
                width: imageWidth, // Hardcoded width
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover, // Crop to fill the space
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: imageHeight,
                      width: imageWidth,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),

            // Rest of the card (unchanged)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(icon: Icons.location_on, text: location),
                  const SizedBox(height: 8),
                  _buildInfoRow(icon: Icons.phone, text: contact),
                  const SizedBox(height: 8),
                  _buildInfoRow(icon: Icons.calendar_month, text: eventDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
