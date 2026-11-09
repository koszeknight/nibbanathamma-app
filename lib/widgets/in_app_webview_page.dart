import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nibbana_dhamma/utils/in_app_download_manager.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;
  final String? title;

  const InAppWebViewPage({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _pageTitle = '';
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _pageTitle = widget.title ?? 'Web View';
    _currentUrl = widget.url;
    _initializeWebView();
  }

  @override
  void dispose() {
    // Navigate to a blank page to immediately stop any playing audio/video
    try {
      _controller.loadRequest(Uri.parse('about:blank'));
    } catch (_) {}
    super.dispose();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36')
      ..setBackgroundColor(InAppDownloadManager.isAudioUrl(widget.url)
          ? const Color(0xFF181413)
          : Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
                _isLoading = progress < 100;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
                if (!InAppDownloadManager.isAudioUrl(widget.url)) {
                  _currentUrl = url;
                }
              });
            }
          },
          onPageFinished: (String url) async {
            if (mounted) {
              setState(() {
                _isLoading = false;
                if (!InAppDownloadManager.isAudioUrl(widget.url)) {
                  _currentUrl = url;
                }
              });
              try {
                final docTitle = await _controller.getTitle();
                if (docTitle != null && docTitle.isNotEmpty && mounted) {
                  setState(() {
                    if (widget.title == null || widget.title!.isEmpty) {
                      _pageTitle = docTitle;
                    }
                  });
                }
              } catch (_) {}
            }
          },
          onWebResourceError: (WebResourceError error) {
            // Only trigger error state if the MAIN FRAME failed to load.
            // Subresources (trackers, analytics, ads, missing images, favicons)
            // or cancelled/delegated navigations must not show an error screen.
            final isMainFrame = error.isForMainFrame ?? false;
            final isCancelled = error.errorCode == -10 || error.errorCode == -1;

            if (mounted && isMainFrame && !isCancelled) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final targetUrl = request.url;

            // Stream audio files directly in the in-app player
            if (InAppDownloadManager.isAudioUrl(targetUrl)) {
              if (mounted) {
                setState(() {
                  _currentUrl = targetUrl;
                });
                _loadContent(targetUrl);
              }
              return NavigationDecision.prevent;
            }

            // Check if this is an in-app downloadable file
            if (InAppDownloadManager.isDownloadableUrl(targetUrl)) {
              InAppDownloadManager.downloadFile(
                context,
                targetUrl,
                customFileName: _pageTitle,
              );
              return NavigationDecision.prevent;
            }

            // Handle external contact schemes (phone, mail, whatsapp)
            if (targetUrl.startsWith('tel:') ||
                targetUrl.startsWith('mailto:') ||
                targetUrl.startsWith('whatsapp:') ||
                targetUrl.contains('wa.me/')) {
              final externalUri = Uri.tryParse(targetUrl);
              if (externalUri != null) {
                launchUrl(externalUri, mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }

            // Prevent YouTube/Google from escaping to external apps via intent://
            // by keeping navigation inside this webview
            if (targetUrl.startsWith('intent:')) {
              final webUrl = _extractWebUrlFromIntent(targetUrl);
              if (webUrl != null &&
                  webUrl.isNotEmpty &&
                  webUrl != _currentUrl) {
                _controller.loadRequest(Uri.parse(webUrl));
              }
              return NavigationDecision.prevent;
            }

            // Prevent direct app launch scheme for YouTube so it stays inside the app
            if (targetUrl.startsWith('vnd.youtube:') ||
                targetUrl.startsWith('market:')) {
              return NavigationDecision.prevent;
            }

            // Allow standard secure web browsing
            if (targetUrl.startsWith('https://') ||
                targetUrl.startsWith('http://')) {
              return NavigationDecision.navigate;
            }

            // Prevent any malicious or arbitrary schemes (e.g. javascript:, file:, data:)
            return NavigationDecision.prevent;
          },
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    final safeUrl = _formatUrl(widget.url);
    _loadContent(safeUrl);
  }

  void _loadContent(String url) {
    if (InAppDownloadManager.isAudioUrl(url)) {
      _controller.loadHtmlString(
        _buildAudioPlayerHtml(url, _pageTitle),
        baseUrl: url,
      );
    } else {
      _controller.loadRequest(Uri.parse(url));
    }
  }

  String? _extractWebUrlFromIntent(String intentUrl) {
    try {
      final fallbackMatch =
          RegExp(r'S\.browser_fallback_url=([^;]+)').firstMatch(intentUrl);
      if (fallbackMatch != null) {
        return Uri.decodeComponent(fallbackMatch.group(1)!);
      }

      if (intentUrl.startsWith('intent://')) {
        final hashIndex = intentUrl.indexOf('#Intent');
        final rawTarget = hashIndex != -1
            ? intentUrl.substring(9, hashIndex)
            : intentUrl.substring(9);
        var scheme = 'https';
        final schemeMatch =
            RegExp(r'scheme=([a-zA-Z]+);').firstMatch(intentUrl);
        if (schemeMatch != null) {
          scheme = schemeMatch.group(1) ?? 'https';
        }
        return '$scheme://$rawTarget';
      }
    } catch (_) {}
    return null;
  }

  String _buildAudioPlayerHtml(String audioUrl, String title) {
    final escapedTitle = const HtmlEscape().convert(title);
    String mimeType = 'audio/mpeg';
    final lower = audioUrl.toLowerCase();
    if (lower.contains('.wav')) {
      mimeType = 'audio/wav';
    } else if (lower.contains('.m4a') || lower.contains('.aac')) {
      mimeType = 'audio/mp4';
    } else if (lower.contains('.ogg')) {
      mimeType = 'audio/ogg';
    }

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <title>$escapedTitle</title>
  <style>
    * {
      box-sizing: border-box;
      -webkit-tap-highlight-color: transparent;
    }
    body {
      margin: 0;
      padding: 24px 16px;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      background: #181413;
      color: #ffffff;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    .player-card {
      background: #25201d;
      border: 1px solid rgba(255, 111, 0, 0.25);
      border-radius: 24px;
      padding: 36px 24px 28px 24px;
      width: 100%;
      max-width: 440px;
      box-shadow: 0 16px 40px rgba(0, 0, 0, 0.6);
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
    }
    .icon-container {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: linear-gradient(135deg, #ff6f00, #e65100);
      display: flex;
      justify-content: center;
      align-items: center;
      margin-bottom: 20px;
      box-shadow: 0 10px 24px rgba(230, 81, 0, 0.45);
    }
    .icon-container svg {
      width: 42px;
      height: 42px;
      fill: #ffffff;
    }
    .title {
      font-size: 16px;
      font-weight: 600;
      line-height: 1.5;
      margin-bottom: 24px;
      color: #ffffff;
      word-break: break-word;
    }
    audio {
      width: 100%;
      outline: none;
      border-radius: 30px;
    }
    .badge {
      margin-top: 24px;
      font-size: 12px;
      letter-spacing: 0.5px;
      color: #ffab40;
      background: rgba(255, 111, 0, 0.12);
      padding: 6px 14px;
      border-radius: 12px;
      font-weight: 500;
    }
  </style>
</head>
<body>
  <div class="player-card">
    <div class="icon-container">
      <svg viewBox="0 0 24 24"><path d="M12 3v9.28c-.47-.17-.97-.28-1.5-.28C8.01 12 6 14.01 6 16.5S8.01 21 10.5 21c2.31 0 4.2-1.75 4.45-4H15V6h4V3h-7z"/></svg>
    </div>
    <div class="title">$escapedTitle</div>
    <audio controls autoplay preload="auto">
      <source src="$audioUrl" type="$mimeType">
      Your browser does not support audio playback.
    </audio>
    <div class="badge">Nibbana Dhamma Audio</div>
  </div>
</body>
</html>
''';
  }

  String _formatUrl(String rawUrl) {
    var trimmed = rawUrl.trim();
    final lower = trimmed.toLowerCase();

    // Block dangerous non-web schemes
    if (lower.startsWith('javascript:') ||
        lower.startsWith('file:') ||
        lower.startsWith('data:') ||
        lower.startsWith('content:')) {
      return 'about:blank';
    }

    if (!lower.startsWith('http://') && !lower.startsWith('https://')) {
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

  String _getHostDisplay(String urlString) {
    try {
      final uri = Uri.parse(urlString);
      return uri.host.isNotEmpty ? uri.host : urlString;
    } catch (_) {
      return urlString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _pageTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _getHostDisplay(_currentUrl),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          if (InAppDownloadManager.isAudioUrl(_currentUrl) ||
              InAppDownloadManager.isAudioUrl(widget.url))
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              tooltip: 'Download Audio',
              onPressed: () {
                InAppDownloadManager.downloadFile(
                  context,
                  _currentUrl.isNotEmpty ? _currentUrl : widget.url,
                  customFileName: _pageTitle,
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            tooltip: 'Back',
            onPressed: () async {
              if (await _controller.canGoBack()) {
                await _controller.goBack();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            tooltip: 'Forward',
            onPressed: () async {
              if (await _controller.canGoForward()) {
                await _controller.goForward();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () {
              if (InAppDownloadManager.isAudioUrl(_currentUrl)) {
                _loadContent(_currentUrl);
              } else {
                _controller.reload();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open in Browser / App',
            onPressed: () async {
              final target = _currentUrl.isNotEmpty ? _currentUrl : widget.url;
              final uri = Uri.tryParse(target);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _loadingProgress > 0 ? _loadingProgress / 100 : null,
                backgroundColor: Colors.transparent,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                minHeight: 3,
              ),
            ),
          if (_hasError)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load webpage',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Could not connect to $_currentUrl',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _isLoading = true;
                            });
                            if (InAppDownloadManager.isAudioUrl(_currentUrl)) {
                              _loadContent(_currentUrl);
                            } else {
                              _controller.reload();
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final target =
                                _currentUrl.isNotEmpty ? _currentUrl : widget.url;
                            final uri = Uri.tryParse(target);
                            if (uri != null) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open in Browser / App'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepOrange,
                            side: const BorderSide(color: Colors.deepOrange),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
