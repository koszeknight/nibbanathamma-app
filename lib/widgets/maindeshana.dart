import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utils/app_url_launcher.dart';

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

  Future<void> _openAudioInApp(BuildContext context) async {
    await AppUrlLauncher.openUrl(context, audioUrl, title: title);
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
        onTap: () => _openAudioInApp(context),
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
