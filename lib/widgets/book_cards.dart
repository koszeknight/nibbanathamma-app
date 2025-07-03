import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookCards extends StatelessWidget {
  final String bookName;
  final String bookImagePath;
  final String? pdfUrl; // Add this parameter for the PDF URL

  const BookCards({
    super.key,
    required this.bookName,
    required this.bookImagePath,
    this.pdfUrl,
  });

  // Future<void> _launchPdf(BuildContext context) async {
  //   if (pdfUrl == null) return;

  //   final Uri uri = Uri.parse(pdfUrl!);
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Could not launch the PDF')),
  //     );
  //   }
  // }

  Future<void> _launchPdf(BuildContext context) async {
    if (pdfUrl == null) return;

    try {
      final Uri uri = Uri.parse(pdfUrl!);

      // For Google Drive links, use this format for direct download:
      if (pdfUrl!.contains('drive.google.com')) {
        final fileId = pdfUrl!.split('/d/')[1].split('/')[0];
        final directUrl =
            'https://drive.google.com/uc?export=download&id=$fileId';
        if (await canLaunchUrl(Uri.parse(directUrl))) {
          await launchUrl(Uri.parse(directUrl));
          return;
        }
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDF: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _launchPdf(context),
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    bookImagePath,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to view & download PDF',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.download,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
