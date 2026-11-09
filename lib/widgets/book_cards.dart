import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utils/app_url_launcher.dart';

class BookCards extends StatelessWidget {
  final String bookName;
  final String bookImagePath;
  final String pdfUrl;

  const BookCards({
    super.key,
    required this.bookName,
    required this.bookImagePath,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Book image section - FIXED GOOGLE DRIVE ISSUE HERE
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: bookImagePath.isNotEmpty
                  ? _buildBookImage()
                  : const Center(
                      child: Icon(
                        Icons.book_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Book name
            Text(
              bookName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Download button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pdfUrl.isNotEmpty
                    ? () {
                        _openPdf(context, pdfUrl);
                      }
                    : null,
                icon: const Icon(Icons.download),
                label: const Text('Tap to view & download PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    // Check if it's a network URL (starts with http)
    if (bookImagePath.startsWith('http')) {
      // Convert Google Drive URL if needed
      String imageUrl = _fixGoogleDriveUrl(bookImagePath);

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Show the URL that failed for debugging
            return _buildErrorImageWithUrl(imageUrl);
          },
        ),
      );
    } else {
      // For local assets
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          bookImagePath,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorImage();
          },
        ),
      );
    }
  }

  String _fixGoogleDriveUrl(String url) {
    // Handle different Google Drive URL formats

    // Format 1: https://drive.google.com/file/d/{fileId}/view
    if (url.contains('/file/d/')) {
      final start = url.indexOf('/file/d/') + 8;
      final end = url.indexOf('/', start);
      if (end != -1) {
        final fileId = url.substring(start, end);
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      }
    }

    // Format 2: https://drive.google.com/open?id={fileId}
    else if (url.contains('id=')) {
      final start = url.indexOf('id=') + 3;
      final end = url.indexOf('&', start);
      final fileId =
          end != -1 ? url.substring(start, end) : url.substring(start);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }

    // Format 3: https://drive.usercontent.google.com/download?id={fileId}
    else if (url.contains('drive.usercontent.google.com')) {
      try {
        final uri = Uri.parse(url);
        final fileId = uri.queryParameters['id'];
        if (fileId != null) {
          // This is a download link, convert to view link
          return 'https://drive.google.com/uc?export=view&id=$fileId';
        }
      } catch (e) {
        // If parsing fails, return original URL
        return url;
      }
    }

    // Format 4: Direct Google Drive file ID (just the ID)
    else if (_isValidFileId(url)) {
      return 'https://drive.google.com/uc?export=view&id=$url';
    }

    // Return original URL if no Google Drive pattern matches
    return url;
  }

  bool _isValidFileId(String text) {
    // Check if it looks like a Google Drive file ID
    // Google Drive file IDs are typically 25-33 characters
    if (text.length >= 25 && text.length <= 33) {
      // Contains only alphanumeric characters, dashes, and underscores
      final regex = RegExp(r'^[a-zA-Z0-9\-_]+$');
      return regex.hasMatch(text);
    }
    return false;
  }

  Widget _buildErrorImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorImageWithUrl(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              'Failed to load image',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _getShortUrl(url),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getShortUrl(String url) {
    if (url.length > 50) {
      return '${url.substring(0, 25)}...${url.substring(url.length - 25)}';
    }
    return url;
  }

  void _openPdf(BuildContext context, String pdfUrl) {
    if (pdfUrl.isEmpty) return;
    AppUrlLauncher.openPdf(context, pdfUrl, title: bookName);
  }
}
