import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class InAppDownloadManager {
  /// Check if the URL points to an audio stream/file that should play in browser view
  static bool isAudioUrl(String url) {
    final cleanUrl = url.split('?').first.toLowerCase();
    return cleanUrl.endsWith('.mp3') ||
        cleanUrl.endsWith('.m4a') ||
        cleanUrl.endsWith('.wav') ||
        cleanUrl.endsWith('.aac') ||
        cleanUrl.endsWith('.ogg');
  }

  /// Check if the URL points to a downloadable file
  static bool isDownloadableUrl(String url) {
    // Audio files should stream in browser view instead of auto-downloading to device
    if (isAudioUrl(url)) return false;

    final cleanUrl = url.split('?').first.toLowerCase();
    final lowerUrl = url.toLowerCase();

    // Check for common downloadable file extensions
    final downloadExtensions = [
      '.pdf',
      '.mp4',
      '.mkv',
      '.zip',
      '.rar',
      '.tar',
      '.gz',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
      '.apk',
      '.epub',
    ];

    for (final ext in downloadExtensions) {
      if (cleanUrl.endsWith(ext)) return true;
    }

    // Google Drive direct download indicators
    if (lowerUrl.contains('export=download') ||
        lowerUrl.contains('drive.usercontent.google.com/download')) {
      return true;
    }

    return false;
  }

  /// Sanitizes file name to prevent path traversal and filesystem issues
  static String sanitizeFileName(String input) {
    // Strip null bytes, control chars, path traversal sequences, and separators
    var safe = input.replaceAll(RegExp(r'[\x00-\x1F\x7F/\\]'), '_');
    safe = safe.replaceAll(RegExp(r'\.{2,}'), '_');
    safe = safe.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    safe = safe.trim();
    if (safe.isEmpty) {
      safe = 'download_${DateTime.now().millisecondsSinceEpoch}';
    }
    // Limit length to avoid buffer/path overflow
    if (safe.length > 80) {
      safe = safe.substring(0, 80);
    }
    return safe;
  }

  /// Extracts or generates a friendly, sanitized file name from a URL
  static String getFileNameFromUrl(String url, {String? fallbackName}) {
    try {
      final uri = Uri.tryParse(url);
      final pathSegments = uri?.pathSegments ?? [];
      String? extension;

      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last;
        if (lastSegment.contains('.')) {
          extension = lastSegment.substring(lastSegment.lastIndexOf('.'));
        }
      }

      if (fallbackName != null && fallbackName.trim().isNotEmpty) {
        String cleanName = sanitizeFileName(fallbackName.trim());

        // If cleanName doesn't already have an extension, try to add it
        if (!cleanName.contains('.')) {
          if (extension != null) {
            cleanName += sanitizeFileName(extension);
          } else if (url.toLowerCase().contains('.pdf') || url.contains('drive.google.com')) {
            cleanName += '.pdf';
          } else if (url.toLowerCase().contains('.mp3')) {
            cleanName += '.mp3';
          }
        }
        return cleanName;
      }

      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last;
        if (lastSegment.contains('.')) {
          return sanitizeFileName(Uri.decodeComponent(lastSegment));
        }
      }
    } catch (_) {}
    return 'download_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Resolves the device storage directory safely without causing permission exceptions
  static Future<Directory> getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) return extDir;
      } else if (Platform.isIOS) {
        return await getApplicationDocumentsDirectory();
      } else {
        final downloadDir = await getDownloadsDirectory();
        if (downloadDir != null) return downloadDir;
      }
    } catch (_) {}
    return await getApplicationDocumentsDirectory();
  }

  /// Downloads the file locally with progress feedback and presents an in-app viewer/confirmation
  static Future<File?> downloadFile(
    BuildContext context,
    String url, {
    String? customFileName,
    void Function(File downloadedFile)? onDownloaded,
  }) async {
    final fileName = getFileNameFromUrl(url, fallbackName: customFileName);

    // Show download progress dialog
    return showDialog<File>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _DownloadProgressDialog(
          url: url,
          fileName: fileName,
          onComplete: onDownloaded,
        );
      },
    );
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String url;
  final String fileName;
  final void Function(File downloadedFile)? onComplete;

  const _DownloadProgressDialog({
    required this.url,
    required this.fileName,
    this.onComplete,
  });

  @override
  State<_DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0.0;
  String _status = 'Starting download...';
  bool _isComplete = false;
  bool _hasError = false;
  String _errorMessage = '';
  File? _savedFile;
  String _displayLocation = '';

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    HttpClient? client;
    IOSink? sink;
    try {
      final uri = Uri.tryParse(widget.url);
      if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        throw const FormatException('Invalid or unsupported URL scheme');
      }

      client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final totalBytes = response.contentLength;
        int receivedBytes = 0;

        final dir = await InAppDownloadManager.getDownloadDirectory();
        final safeFileName = InAppDownloadManager.sanitizeFileName(widget.fileName);
        final savePath = '${dir.path}/$safeFileName';
        final file = File(savePath);
        sink = file.openWrite();

        await for (final chunk in response) {
          receivedBytes += chunk.length;
          sink.add(chunk);
          if (totalBytes > 0 && mounted) {
            setState(() {
              _progress = receivedBytes / totalBytes;
              _status =
                  '${(receivedBytes / (1024 * 1024)).toStringAsFixed(2)} MB / ${(totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
            });
          } else if (mounted) {
            setState(() {
              _status = '${(receivedBytes / 1024).toStringAsFixed(1)} KB downloaded';
            });
          }
        }

        await sink.flush();
        await sink.close();
        sink = null;

        if (mounted) {
          setState(() {
            _savedFile = file;
            _isComplete = true;
            _progress = 1.0;
            _status = 'Download completed successfully!';
            _displayLocation = 'Saved to: ${file.path}';
          });

          widget.onComplete?.call(file);
        }
      } else {
        // Fallback using CacheManager and copying to app directory
        final cachedFile = await DefaultCacheManager().getSingleFile(widget.url);
        final dir = await InAppDownloadManager.getDownloadDirectory();
        final safeFileName = InAppDownloadManager.sanitizeFileName(widget.fileName);
        final savePath = '${dir.path}/$safeFileName';
        final savedFile = await cachedFile.copy(savePath);

        if (mounted) {
          setState(() {
            _savedFile = savedFile;
            _isComplete = true;
            _progress = 1.0;
            _status = 'Saved to Downloads folder!';
            _displayLocation = 'Saved to: ${savedFile.path}';
          });
          widget.onComplete?.call(savedFile);
        }
      }
    } catch (e) {
      // Try fallback with CacheManager
      try {
        final cachedFile = await DefaultCacheManager().getSingleFile(widget.url);
        final dir = await InAppDownloadManager.getDownloadDirectory();
        final safeFileName = InAppDownloadManager.sanitizeFileName(widget.fileName);
        final savePath = '${dir.path}/$safeFileName';
        final savedFile = await cachedFile.copy(savePath);

        if (mounted) {
          setState(() {
            _savedFile = savedFile;
            _isComplete = true;
            _progress = 1.0;
            _status = 'Saved to Downloads folder!';
            _displayLocation = 'Saved to: ${savedFile.path}';
          });
          widget.onComplete?.call(savedFile);
        }
      } catch (fallbackError) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Download failed: $fallbackError';
          });
        }
      }
    } finally {
      try {
        await sink?.close();
      } catch (_) {}
      client?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            _isComplete
                ? Icons.check_circle
                : (_hasError ? Icons.error : Icons.cloud_download),
            color: _isComplete
                ? Colors.green
                : (_hasError ? Colors.red : Colors.deepOrange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isComplete
                  ? 'Download Complete'
                  : (_hasError ? 'Download Failed' : 'Downloading In-App'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fileName,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          if (!_hasError) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _isComplete ? 1.0 : (_progress > 0 ? _progress : null),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isComplete ? Colors.green : Colors.deepOrange,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _status,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (_isComplete && _savedFile != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder, size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _displayLocation.isNotEmpty
                            ? _displayLocation
                            : 'Saved to Downloads: ${widget.fileName}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
        ],
      ),
      actions: [
        if (_isComplete)
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(_savedFile),
            icon: const Icon(Icons.done),
            label: const Text('OK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
          )
        else if (_hasError)
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Close'),
          )
        else
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
      ],
    );
  }
}
