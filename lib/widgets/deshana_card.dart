import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioPageCard extends StatelessWidget {
  final String title;
  final String audioUrl;
  final Color bgColor;

  const AudioPageCard({
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _openAudioInBrowser,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.play_arrow, color: Colors.blue, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
