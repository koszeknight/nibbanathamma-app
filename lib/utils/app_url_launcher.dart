import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nibbana_dhamma/utils/in_app_download_manager.dart';
import 'package:nibbana_dhamma/widgets/in_app_webview_page.dart';

class AppUrlLauncher {
  /// Checks whether a given URL points to a YouTube video, short, or channel.
  static bool isYouTubeUrl(String url) {
    final lower = url.trim().toLowerCase();
    return lower.contains('youtube.com') ||
        lower.contains('youtu.be') ||
        lower.startsWith('vnd.youtube:');
  }

  /// Sanitizes HTTP/HTTPS URLs and upgrades cleartext YouTube URLs to HTTPS.
  static String sanitizeUrl(String rawUrl) {
    var trimmed = rawUrl.trim();
    if (!trimmed.toLowerCase().startsWith('http://') &&
        !trimmed.toLowerCase().startsWith('https://')) {
      trimmed = 'https://$trimmed';
    }
    // Upgrade http to https for YouTube domains to prevent cleartext errors on Android 9+
    if (trimmed.toLowerCase().startsWith('http://www.youtube.com') ||
        trimmed.toLowerCase().startsWith('http://youtube.com') ||
        trimmed.toLowerCase().startsWith('http://m.youtube.com')) {
      trimmed = 'https://${trimmed.substring(7)}';
    }
    return trimmed;
  }

  /// Opens any URL safely within the app.
  /// - YouTube channels and video deshana open within the embedded `InAppWebViewPage`.
  /// - `tel:` links are sanitized against USSD injection and open the device dialer.
  /// - WhatsApp links (`wa.me` or `whatsapp:`) open in the external WhatsApp application.
  /// - Downloadable files (.pdf, archives, documents) can be downloaded in-app.
  /// - Audio sermons (.mp3, etc.) and safe web links open/stream within the embedded `InAppWebViewPage`.
  /// - Malicious schemes (`javascript:`, `file:`, `data:`) are strictly blocked.
  static Future<void> openUrl(
    BuildContext context,
    String url, {
    String? title,
  }) async {
    final trimmedUrl = url.trim();
    if (trimmedUrl.isEmpty) return;

    // Handle telephone dialer scheme safely
    if (trimmedUrl.startsWith('tel:')) {
      final rawNumber = trimmedUrl.substring(4);
      // Strip dangerous characters (USSD codes *, #) to prevent dialer exploits
      final sanitizedNumber = rawNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      if (sanitizedNumber.isEmpty) return;

      final uri = Uri(scheme: 'tel', path: sanitizedNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not place call to $sanitizedNumber')),
        );
      }
      return;
    }

    // Handle WhatsApp links via external app launcher
    if (trimmedUrl.contains('wa.me/') || trimmedUrl.startsWith('whatsapp:')) {
      final uri = Uri.tryParse(trimmedUrl);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    if (!context.mounted) return;

    // Check if the URL is an in-app downloadable file
    if (InAppDownloadManager.isDownloadableUrl(trimmedUrl)) {
      await InAppDownloadManager.downloadFile(
        context,
        trimmedUrl,
        customFileName: title,
      );
      return;
    }

    // Validate URI and block dangerous non-HTTP schemes
    final safeUrl = sanitizeUrl(trimmedUrl);
    final parsedUri = Uri.tryParse(safeUrl);

    if (parsedUri == null ||
        (!parsedUri.isScheme('http') && !parsedUri.isScheme('https'))) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unsupported or invalid link')),
        );
      }
      return;
    }

    // Open within embedded In-App WebView (loads videos and channels inside the app)
    if (context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InAppWebViewPage(
            url: parsedUri.toString(),
            title: title,
          ),
        ),
      );
    }
  }

  /// Opens a YouTube video or channel directly within the embedded in-app WebView.
  static Future<void> openYouTubeUrl(
    BuildContext context,
    String url, {
    String? title,
  }) async {
    await openUrl(context, url, title: title);
  }

  /// Opens a PDF document inside the embedded In-App WebView using Google Docs Viewer
  /// or downloads the PDF locally for offline viewing.
  static Future<void> openPdf(
    BuildContext context,
    String pdfUrl, {
    String? title,
  }) async {
    final trimmedUrl = pdfUrl.trim();
    if (trimmedUrl.isEmpty) return;

    if (!context.mounted) return;

    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Dhamma Book PDF',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE0B2),
                    child: Icon(Icons.visibility, color: Colors.deepOrange),
                  ),
                  title: const Text('Read Online in App'),
                  subtitle: const Text('Preview PDF directly inside the app'),
                  onTap: () => Navigator.of(sheetContext).pop('view'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE0B2),
                    child: Icon(Icons.download_for_offline, color: Colors.deepOrange),
                  ),
                  title: const Text('Download to App Storage'),
                  subtitle: const Text('Save PDF locally for offline reading'),
                  onTap: () => Navigator.of(sheetContext).pop('download'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice == 'view' && context.mounted) {
      final bool isGoogleDrive = trimmedUrl.contains('drive.google.com');
      final viewerUrl = isGoogleDrive
          ? trimmedUrl
          : 'https://docs.google.com/viewer?embedded=true&url=${Uri.encodeComponent(trimmedUrl)}';

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InAppWebViewPage(
            url: viewerUrl,
            title: title ?? 'PDF Preview',
          ),
        ),
      );
    } else if (choice == 'download' && context.mounted) {
      await InAppDownloadManager.downloadFile(
        context,
        trimmedUrl,
        customFileName: title,
      );
    }
  }
}
