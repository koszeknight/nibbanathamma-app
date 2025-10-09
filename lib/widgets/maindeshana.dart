import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioCard extends StatelessWidget {
  final String title;
  final String audioUrl;
  final Color bgColor;

  const AudioCard({
    super.key,
    required this.title,
    required this.audioUrl,
    required this.bgColor,
  });

  Future<void> _openAudioInBrowser() async {
    final uri = Uri.parse(audioUrl);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $audioUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _openAudioInBrowser,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.play_arrow, color: Colors.blue, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
