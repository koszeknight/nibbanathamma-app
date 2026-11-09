import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class OfflineBannerWrapper extends StatefulWidget {
  final Widget child;

  const OfflineBannerWrapper({super.key, required this.child});

  @override
  State<OfflineBannerWrapper> createState() => _OfflineBannerWrapperState();
}

class _OfflineBannerWrapperState extends State<OfflineBannerWrapper> {
  StreamSubscription<InternetStatus>? _subscription;
  bool _bannerShown = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;
      if (status == InternetStatus.disconnected) {
        _showOfflineBanner();
      } else if (status == InternetStatus.connected) {
        _hideOfflineBanner();
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    if (!hasInternet && mounted) {
      _showOfflineBanner();
    }
  }

  void _showOfflineBanner() {
    if (_bannerShown) return;
    setState(() {
      _bannerShown = true;
    });

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('Internet connection required for the best experience. Please check your network connection.'),
        leading: const Icon(Icons.wifi_off, color: Colors.white),
        backgroundColor: Colors.red[800],
        contentTextStyle: const TextStyle(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              _bannerShown = false;
            },
            child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _hideOfflineBanner() {
    if (!_bannerShown) return;
    setState(() {
      _bannerShown = false;
    });
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
