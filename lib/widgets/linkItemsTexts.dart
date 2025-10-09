import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkList extends StatelessWidget {
  final List<Map<String, String>> links;
  final double fontSize;
  final Color linkColor;
  final bool underline;

  const LinkList({
    super.key,
    required this.links,
    this.fontSize = 13,
    this.linkColor = Colors.blue,
    this.underline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: links
          .map((link) => Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(link['url']!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      print("Could not launch ${link['url']}");
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        link['title']!,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                          color: linkColor,
                          decoration: underline
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
