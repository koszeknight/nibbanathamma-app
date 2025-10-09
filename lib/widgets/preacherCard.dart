import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Preachercard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final String? placeUrl; // Made optional
  final Color bgColor;
  final bool
      showExpandableSection; // New parameter to control expandable section

  const Preachercard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.bgColor,
    this.placeUrl, // Made optional
    this.showExpandableSection =
        true, // Default to true for backward compatibility
  });

  @override
  State<Preachercard> createState() => _DetailsCardUrlState();
}

class _DetailsCardUrlState extends State<Preachercard> {
  bool _isExpanded = false;

  Future<void> _launchUrl() async {
    if (widget.placeUrl != null && widget.placeUrl!.isNotEmpty) {
      if (!await launchUrl(Uri.parse(widget.placeUrl!))) {
        throw Exception('Could not launch ${widget.placeUrl}');
      }
    }
  }

  // Check if the image path is a network URL
  bool get _isNetworkImage {
    return widget.imagePath.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.bgColor,
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
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _isNetworkImage
                  ? CachedNetworkImage(
                      imageUrl: widget.imagePath,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.error,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    )
                  : Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Text(
              widget.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 12,
              ),
              maxLines: 3, // Show only 3 lines initially
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Expandable section - only show if enabled
            if (widget.showExpandableSection) _buildExpandableSection(),

            // External link - only show if URL is provided
            if (widget.placeUrl != null && widget.placeUrl!.isNotEmpty)
              _buildExternalLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isExpanded ? "Hide Details" : "View Details",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.blue,
                size: 16,
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text(
                  "පරම සත්‍ය පෙන්වා වදාළ​ අති පූජනීය බුද්ධ පුත්‍ර මීවනපළානේ සිරි ධම්මාලංකාර මහ තෙරුණ් වහන්සේ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "1942 අපේ‍්‍රල් මස 12 වන දින රයිගම් කෝර්ළයට අයත් මීවනපළාන ග‍්‍රාමයේ පදිංචි විලියම් හපුතන්ත‍්‍රී සහ ඇලිස් හපුආරච්චි යන ප‍්‍රභූ දෙපළ පුත් රුවනක් ලදහ. තමන්ගේ පළමු පිරිමි දරුවා වූ මෙම කුල කුමරුවා සිරිසේන හපුතන්තී‍්‍ර යනුවෙන් නම් තැබූහ. කල්ගත වෙද්දී සිරිසේන හපුතන්ත‍්‍රී දරුවා සහෝදර සහෝදරියන් පස් දෙනෙකු මැද සියලූ සැප සම්පත් ලැබ හැදී වැඩුනේය. \n \n මීවනපළානේ (තම ගමේ) රජයේ විද්‍යාලයෙන් ප‍්‍රාථමික අධ්‍යාපනය හදාරා පසුව ද්විතීයක අධ්‍යාපනය සඳහා හොරණ තක්‍ෂිලා මධ්‍ය මහා විද්‍යාලයට ඇතුළත් වූ සිරිසේන හපුතන්ත‍්‍රී, විදුහලේ දීප්තිමත් ශිෂ්‍යයෙකු වශයෙන් තම සරසවි පිවිසුම් පෙළ විභාගය ඉහළින්ම සමත් වූයේය. ඒ 1962 වර්ෂයේදීය​. වර්ෂ 1963 පේරාදෙණි සරසවියට ඇතුළත් වීමට වරම් ලද මොහු සංඛ්‍යා ලේඛණය හා ආර්ථික විද්‍යාව යන විෂය ධාරාවන්ගෙන් විශේෂ උපාධියක් ලබා උසස් අධ්‍යාපනය ලැබීය.",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                // Add more content as needed
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildExternalLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: _launchUrl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.link,
              size: 16,
              color: Colors.blue,
            ),
            SizedBox(width: 4),
            Text(
              "Visit",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
