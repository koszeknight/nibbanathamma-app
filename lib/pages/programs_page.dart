import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utils/app_url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  String whatsappNumber = '';
  String callNumber = '';
  String videoId = '';
  String googleFormUrl = '';
  String webUrl = '';
  String imageUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndFetchData();
  }

  Future<void> _initializeFirebaseAndFetchData() async {
    try {
      // Fetch data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('programs_links')
          .doc('SHKtadBp1WhfGcKdoH6K')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (mounted) {
          setState(() {
            final rawWhatsapp = data['live_contact_whatsApp']?.toString() ?? '';
            final rawPhone = data['live_contact_phone']?.toString() ?? '';
            whatsappNumber = rawWhatsapp.replaceAll('+', '').trim();
            callNumber = rawPhone.replaceAll('+', '').trim();
            videoId = data['live_VideoUrl']?.toString() ?? '';
            googleFormUrl = data['bw_Next_Prg_FormUrl']?.toString() ?? '';
            webUrl = data['bw_web_url']?.toString() ?? '';
            imageUrl = data['img']?.toString() ?? '';
            isLoading = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint('Error fetching programs data: $e');
    }

    if (mounted) {
      // Fallback default values
      setState(() {
        whatsappNumber = '94771753032';
        callNumber = '94727012240';
        videoId = 'K18cpp_-gP8';
        googleFormUrl =
            'https://docs.google.com/forms/d/e/1FAIpQLSe2m6tziaONmes_NaTlz7p8T_EfTux0UN9IabwsQUa1K8rZWw/viewform';
        webUrl = 'https://arahath.net/application/';
        imageUrl =
            'https://drive.google.com/file/d/1kQmV5qLx0gHvtg3IPyhvbh2zqlzjF36g/view?usp=sharing';
        isLoading = false;
      });
    }
  }

  Future<void> _launchLiveVideo() async {
    final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
    await AppUrlLauncher.openUrl(context, youtubeUrl, title: 'Live Deshana');
  }

  Future<void> _launchGoogleForm() async {
    await AppUrlLauncher.openUrl(context, googleFormUrl, title: 'Google Form');
  }

  Future<void> _launchWebLink() async {
    await AppUrlLauncher.openUrl(context, webUrl, title: 'Program Details');
  }

  Future<void> _launchWhatsApp() async {
    final url = 'https://wa.me/$whatsappNumber';
    await AppUrlLauncher.openUrl(context, url, title: 'WhatsApp');
  }

  Future<void> _makePhoneCall() async {
    final url = 'tel:$callNumber';
    await AppUrlLauncher.openUrl(context, url);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ධම්ම වැඩසටහන්"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 216)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "සජීවී වැඩසටහන්",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Live Video Card - Now opens externally
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.play_circle_filled,
                            color: Colors.red, size: 40),
                        title: const Text(
                          "සජීවී දේශනා නරඹන්න",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                            "Tap to watch in app"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: _launchLiveVideo,
                      ),
                    ),

                    // Alternative: Video Thumbnail with Play Button
                    GestureDetector(
                      onTap: _launchLiveVideo,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // YouTube thumbnail
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black87,
                              ),
                              child: Image.network(
                                'https://img.youtube.com/vi/$videoId/0.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.videocam,
                                            size: 50, color: Colors.white54),
                                        SizedBox(height: 8),
                                        Text(
                                          'Live Stream',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Play button overlay
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),

                            // Live badge
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      "පහත සදහන් දුරකථන අංක වලින් දහම් ගැටලු විමසිය හැක:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // WhatsApp Contact Card
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.chat, color: Colors.green),
                        title: const Text("Send WhatsApp Message"),
                        subtitle: Text(
                            "+${whatsappNumber.substring(0, 2)} ${whatsappNumber.substring(2, 5)} ${whatsappNumber.substring(5)}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: _launchWhatsApp,
                      ),
                    ),

                    // Phone Call Card
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.phone, color: Colors.blue),
                        title: const Text("Make a Phone Call"),
                        subtitle: Text(
                            "+${callNumber.substring(0, 2)} ${callNumber.substring(2, 5)} ${callNumber.substring(5)}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: _makePhoneCall,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 216)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      "බුද්ධ භාවනා වැඩ සටහන් ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 250,
                      height: 350,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(height: 20),
                    const Text("සහභාගී වීමට අමතන්න"),

                    // Add to WhatsApp group
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.chat, color: Colors.green),
                        title: const Text("Send WhatsApp Message"),
                        subtitle: Text(
                            "+${whatsappNumber.substring(0, 2)} ${whatsappNumber.substring(2, 5)} ${whatsappNumber.substring(5)}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: _launchWhatsApp,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "මීළඟ වැඩසටහනට සම්බන්ධ වීමට Google Form එක පුරවන්න",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: _launchGoogleForm,
                      child: const Text(
                        "Open Google Form link",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "බුද්ධ භාවනා වැඩ සටහන් පිළිබද වැඩි දුර තොරතුරු ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: _launchWebLink,
                      child: const Text(
                        "Open external link",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}


