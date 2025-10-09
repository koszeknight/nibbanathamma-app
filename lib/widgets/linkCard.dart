import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCard extends StatelessWidget {
  final String title;
  final String url;
  final IconData icon;
  final Color bgColor;

  const LinkCard({
    super.key,
    required this.title,
    required this.url,
    required this.icon,
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _launchUrl,
        child: Padding(
          padding: const EdgeInsets.all(8),
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(icon, color: Colors.blue, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterLinks extends StatelessWidget {
  final List<Map<String, dynamic>> links = [
    {
      'title': 'Motorcycle Safety',
      'url': 'https://www.example.com/motorcycle-safety',
      'icon': Icons.motorcycle,
    },
    {
      'title': 'Roadway Vision',
      'url': 'https://www.youtube.com/roadwayvision',
      'icon': Icons.video_library,
    },
    {
      'title': 'Automat Recovery',
      'url': 'https://www.example.com/automat-recovery',
      'icon': Icons.build,
    },
    // Add more links as needed
  ];

  FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Useful Links',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ...links.map((link) => LinkCard(
              title: link['title'],
              url: link['url'],
              icon: link['icon'],
              bgColor: Colors.grey[100] ?? Colors.white,
            )),
      ],
    );
  }
}
