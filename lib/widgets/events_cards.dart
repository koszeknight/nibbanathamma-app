import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/image_viewer_page.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String contact;
  final String eventDate;
  final String? imageUrl;
  final double? cardWidth;

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.contact,
    required this.eventDate,
    this.imageUrl,
    this.cardWidth,
  });

  Future<void> _launchUrl(BuildContext context) async {
    if (imageUrl == null || imageUrl!.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewerPage(
          imageUrl: imageUrl!,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth ?? double.infinity,
      constraints: const BoxConstraints(
        minHeight: 280, // Minimum height
        maxHeight: 380, // Maximum height
      ),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important: takes minimum space
          children: [
            // Image Section
            if (imageUrl != null && imageUrl!.isNotEmpty)
              InkWell(
                onTap: () => _launchUrl(context),
                child: SizedBox(
                  width: double.infinity,
                  height: 200, // Fixed image height
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.event,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Content Section - Dynamic height
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Takes minimum space
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Contact
                  if (contact.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            contact,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (contact.isNotEmpty) const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_month,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          eventDate,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
