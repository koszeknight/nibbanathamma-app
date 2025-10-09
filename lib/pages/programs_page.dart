import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
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
      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Fetch data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('programs_links') // your collection name
          .doc('SHKtadBp1WhfGcKdoH6K') // your document ID
          .get();

      if (doc.exists) {
        setState(() {
          whatsappNumber = doc['live_contact_whatsApp'].replaceAll('+', '');
          callNumber = doc['live_contact_phone'].replaceAll('+', '');
          videoId = doc['live_VideoUrl'];
          googleFormUrl = doc['bw_Next_Prg_FormUrl'];
          webUrl = doc['bw_web_url'];
          imageUrl = doc['img'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Set default values in case of error
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
    String youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';

    // Try to open in YouTube app first, then fall back to browser
    final Uri uri = Uri.parse(youtubeUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode:
              LaunchMode.externalApplication, // Opens in YouTube app or browser
        );
      } else {
        // Fallback: Try the YouTube mobile URL
        final Uri mobileUri =
            Uri.parse('https://m.youtube.com/watch?v=$videoId');
        if (await canLaunchUrl(mobileUri)) {
          await launchUrl(
            mobileUri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print('Error launching YouTube: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the video. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchGoogleForm() async {
    if (!await launchUrl(Uri.parse(googleFormUrl))) {
      throw Exception('Could not launch the url');
    }
  }

  Future<void> _launchWebLink() async {
    if (!await launchUrl(Uri.parse(webUrl))) {
      throw Exception('Could not launch the url');
    }
  }

  Future<void> _launchWhatsApp() async {
    final url = 'https://wa.me/$whatsappNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall() async {
    final url = 'tel:$callNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
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
        title: const Text("Dhamma Programs"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 216)),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Poya Live Program",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Live Video Card - Now opens externally
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_filled,
                          color: Colors.red, size: 40),
                      title: const Text(
                        "Watch Live Stream",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          const Text("Tap to watch in YouTube app or browser"),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              color: Colors.red.withOpacity(0.9),
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
                    "Ask your Question:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // WhatsApp Contact Card
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 245, 216)),
              child: Column(
                children: [
                  const Text(
                    "Bawana Program",
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
                  const Text("Contact to Join"),

                  // Add to WhatsApp group
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.chat, color: Colors.green),
                      title: const Text("Send WhatsApp Message"),
                      subtitle: Text(
                          "+${whatsappNumber.substring(0, 2)} ${whatsappNumber.substring(2, 5)} ${whatsappNumber.substring(5)}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _launchWhatsApp,
                    ),
                  ),

                  const Text("Fill the Form to join the Next Program"),
                  GestureDetector(
                    onTap: _launchGoogleForm,
                    child: const Text(
                      "Open external link",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("More Details about Bawana Programs"),
                  GestureDetector(
                    onTap: _launchWebLink,
                    child: const Text(
                      "Open external link",
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
