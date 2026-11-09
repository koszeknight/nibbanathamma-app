import 'package:flutter/foundation.dart';

class ImageUrlHelper {
  // Never route mobile traffic through third-party unverified proxies.
  // Use proxy only if specifically required on Web, otherwise disabled.
  static bool useProxy = false;

  /// Safely converts Google Drive URLs to direct viewing URLs
  static String convertGoogleDriveUrl(String originalUrl) {
    if (originalUrl.isEmpty) return originalUrl;

    try {
      String? fileId;

      if (originalUrl.contains('drive.usercontent.google.com/download')) {
        final uri = Uri.tryParse(originalUrl);
        fileId = uri?.queryParameters['id'];
      } else if (originalUrl.contains('drive.google.com/file/d/')) {
        final regex = RegExp(r'/d/([a-zA-Z0-9_-]{20,})');
        final match = regex.firstMatch(originalUrl);
        fileId = match?.group(1);
      } else if (originalUrl.contains('drive.google.com') && originalUrl.contains('id=')) {
        final uri = Uri.tryParse(originalUrl);
        fileId = uri?.queryParameters['id'];
      } else if (RegExp(r'^[a-zA-Z0-9_-]{20,45}$').hasMatch(originalUrl)) {
        fileId = originalUrl;
      }

      if (fileId != null && fileId.isNotEmpty) {
        final String directUrl =
            'https://drive.google.com/uc?export=view&id=$fileId';

        // Only allow proxy on Web if explicitly requested and running in web platform
        if (kIsWeb && useProxy) {
          return 'https://corsproxy.io/?${Uri.encodeComponent(directUrl)}';
        }

        return directUrl;
      }

      return originalUrl;
    } catch (_) {
      return originalUrl;
    }
  }
}

