import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCardGrid extends StatelessWidget {
  final List<LinkItem> items;

  const LinkCardGrid({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true, // This makes the GridView only take the space it needs
      physics:
          NeverScrollableScrollPhysics(), // Disable scrolling since we're in a SingleChildScrollView
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: items
          .map((item) => LinkCardEdit(
                title: item.title,
                url: item.url,
                imagePath: item.imagePath,
                bgColor: item.bgColor,
              ))
          .toList(),
    );
  }
}

class LinkCardEdit extends StatelessWidget {
  final String title;
  final String url;
  final String imagePath;
  final Color bgColor;

  const LinkCardEdit({
    super.key,
    required this.title,
    required this.url,
    required this.imagePath,
    this.bgColor = Colors.white,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: bgColor, // Moved color parameter here
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _launchUrl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkItem {
  final String title;
  final String url;
  final String imagePath;
  final Color bgColor;

  LinkItem({
    required this.title,
    required this.url,
    required this.imagePath,
    this.bgColor = Colors.white,
  });
}
