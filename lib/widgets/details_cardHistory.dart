import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsCardHistory extends StatelessWidget {
  final String title;
  final String decription;
  final String ImagePath;
  final String placeUrl;
  final Color bgColor;

  const DetailsCardHistory({
    super.key,
    required this.title,
    required this.placeUrl,
    required this.ImagePath,
    required this.decription,
    required this.bgColor,
  });

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(placeUrl))) {
      throw Exception('Could not launch $placeUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                ImagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 20),
            Text(
              decription,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _launchUrl,
              child: Text(
                "View Place",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
