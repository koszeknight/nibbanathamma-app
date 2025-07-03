import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String contact;
  final String eventDate;
  final String? imageUrl;
  final double? cardWidth;

  static const double imageHeight = 132;
  static const double imageWidth = 95;

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
    if (imageUrl == null) return;

    final Uri url = Uri.parse(imageUrl!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the URL')),
        );
      }
    }
  }

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
            const SizedBox(height: 8),
            if (imageUrl != null)
              InkWell(
                onTap: () => _launchUrl(context),
                child: SizedBox(
                  height: imageHeight,
                  width: imageWidth,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: imageHeight,
                        width: imageWidth,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
              ),
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
