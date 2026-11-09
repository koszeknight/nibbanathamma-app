import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/events_data.dart';
import 'package:nibbana_dhamma/utills/colors.dart';
import 'package:nibbana_dhamma/widgets/link_cards_items.dart';
import 'package:nibbana_dhamma/widgets/maindeshana.dart';
import 'package:nibbana_dhamma/widgets/side_menu.dart';
import 'package:nibbana_dhamma/widgets/top_title_bar.dart';
import 'package:nibbana_dhamma/widgets/events_cards.dart';
import 'package:nibbana_dhamma/model/useful_link_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        width: screenSize.width * 0.8,
        child: const SideMenu(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = isPortrait
                ? constraints.maxWidth * 0.04
                : constraints.maxWidth * 0.08;

            return Column(
              children: [
                // Sticky TopTitleBar - stays at top
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const TopTitleBar(),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              height: 10), // Small spacing after title bar

                          // Responsive Details Card
                          ResponsiveDetailsCard(
                            title: "සුවත්ථි හෝතු.",
                            description:
                                "නිවන් අවබෝධ කරගැනීමට උපකාර වන පරිදි එසේ නොමැතිනම් රාගයෙන් දෝසයෙන් මෝහයෙන් සදහටම සහමුළින්ම මිදී නිදහස් වීමට උපකාර වන පරිදි යමෙකු යම් පරියායක් දේසනා කරන්නේද, ඒ උතුමන් ධම්මවාදියෙකු වන්නේය.මෙකල ධම්මවාදී ආරම්භකයා ගොතම සමණ අප තථාගතයන් වහන්සේය.  උන්වහන්සේගේ දේසනාරම්භයෙන් ආරම්භ වූ ගොතම බුද්ධ සාසනය කලින් කලට ඉස්මතු වෙමින් යටපත් වෙමින් විපරිණාම ධම්මයට අනුවම පණ දහසක් කල් පවතින බව පරම සච්චතාවයකි. මේ කාලයද ඒ ආකාරයට ධම්මපරියාය නැවත ඉස්මතු වන යුගයකි. ධම්මපරියාය දේසනා කරන ධම්මවාදීන් ජීවමාන වූ කාලයකි. එම නිසා පුබ්බේත කත පුඤ්ඤතා ඇත්තන්ට සෝතාවධානේ පඤ්ඤා සුතමය ඤාණය ලබන්නට හැකිවන කාලයකි. ඒ අනුව සංවර පටිපදාවෙහි පිහිටා සම්මා විමුත්තියට පත්වන්නට හැකිවන කාලයකි. එම නිසා මේ සොබාදහම්තාවයෙන් සියලු ලෝක සියලු සත්ත්වයෝ සෝතාපන්න ඵලයෙන් නිදුක්වෙත්වා….!!! සකදාගාමී ඵලයෙන් නීරෝගී වෙත්වා….!!! අනාගාමී ඵලයෙන් සුවපත් වෙත්වා….!!! අරහත් ඵලයෙන් දුකින් මිදෙත්වා….!!! පරම නිබ්බාන සුවයෙන් සුවපත් වෙත්වා….!!! යන පරම පිවිතුරු මෙත්තා සහගත අධිට්ඨානයක් පැතිර වීම උතුම්ය. එම උතුම් අධිට්ඨානය පෙර දැරිව ධම්ම දානය පිනිස මෙම යෙදවුම ඔබ සියලු දෙනාටම උපකාරයක්ම වේවා...!",
                            bgColor: detailCardBgColor,
                            isPortrait: isPortrait,
                          ),
                          const SizedBox(height: 20),

                          // Events Section with Onboarding Carousel
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('events')
                                .orderBy('order', descending: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('No upcoming events'));
                              }

                              final events = snapshot.data!.docs
                                  .map((doc) => Event.fromFirestore(doc))
                                  .toList();

                              return EventCarousel(
                                events: events,
                                isPortrait: isPortrait,
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Audio Section
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    const Color.fromARGB(255, 214, 213, 209)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'මූලික දේශනා',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/audio');
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 13,
                                        color: Colors.deepOrange,
                                      ),
                                      label: const Text(
                                        'සියල්ල',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: [
                                    AudioCard(
                                      title: "01-San-Deshanawa.mp3",
                                      audioUrl:
                                          "https://guwana.sirisaddharmaya.net/audio/01-San-Deshanawa.mp3",
                                      bgColor: Colors.orange[100]!,
                                    ),
                                    AudioCard(
                                      title: "02-Dwathawaya.mp3",
                                      audioUrl:
                                          "https://guwana.sirisaddharmaya.net/audio/02-Dwathawaya.mp3",
                                      bgColor: Colors.blue[100]!,
                                    ),
                                    AudioCard(
                                      title: "03-Thipariwattaya.mp3 ",
                                      audioUrl:
                                          "https://guwana.sirisaddharmaya.net/audio/03-Thipariwattaya.mp3",
                                      bgColor: Colors.orange[100]!,
                                    ),
                                    AudioCard(
                                      title: "04-Dukkha-Sathya.mp3  ",
                                      audioUrl:
                                          "https://guwana.sirisaddharmaya.net/audio/04-Dukkha-Sathya.mp3",
                                      bgColor: Colors.blue[100]!,
                                    ),
                                    AudioCard(
                                      title:
                                          "05-patichchasamuppada-dharma-vigrahaya.mp3  ",
                                      audioUrl:
                                          "https://guwana.sirisaddharmaya.net/audio/05-patichchasamuppada-dharma-vigrahaya.mp3",
                                      bgColor: Colors.orange[100]!,
                                    ),
                                    AudioCard(
                                      title: "06-pina-saha-kusalaya.mp3  ",
                                      audioUrl:
                                          "https://guwana.sirisaddharmaya.net/audio/06-pina-saha-kusalaya.mp3",
                                      bgColor: Colors.blue[100]!,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Useful Links Section with Firestore Data
                          const SizedBox(
                            height: 30,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Useful Links",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 50, 157, 245),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20)),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('useful_links')
                                    .orderBy('displayOrder')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      ),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child:
                                            Text('No useful links available'),
                                      ),
                                    );
                                  }

                                  // Convert Firestore documents to UsefulLink objects
                                  final allLinks = snapshot.data!.docs
                                      .map((doc) =>
                                          UsefulLink.fromFirestore(doc))
                                      .toList();

                                  // Separate links by type
                                  final websiteLinks = allLinks
                                      .where((link) =>
                                          link.type == LinkType.website)
                                      .toList();

                                  final youtubeLinks = allLinks
                                      .where((link) =>
                                          link.type == LinkType.youtube)
                                      .toList();

                                  return Column(
                                    children: [
                                      if (websiteLinks.isNotEmpty) ...[
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Main Websites",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        LinkCardGrid(
                                          items: websiteLinks
                                              .map((link) => LinkItem(
                                                    title: link.name,
                                                    url: link.url,
                                                    imageUrl: link.iconUrl,
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                      if (youtubeLinks.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        const Text(
                                          "YouTube Links",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        LinkCardGrid(
                                          items: youtubeLinks
                                              .map((link) => LinkItem(
                                                    title: link.name,
                                                    url: link.url,
                                                    imageUrl: link.iconUrl,
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ResponsiveDetailsCard extends StatelessWidget {
  final String title;
  final String description;
  final Color bgColor;
  final bool isPortrait;

  const ResponsiveDetailsCard({
    super.key,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPortrait ? 16 : 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isPortrait ? 12 : 8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isPortrait ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isPortrait ? 12 : 8),
          Text(
            description,
            style: TextStyle(
              fontSize: isPortrait ? 13 : 11,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

// Onboarding Carousel Widget for Events
// Onboarding Carousel Widget for Events
// Onboarding Carousel Widget for Events
// Onboarding Carousel Widget for Events
class EventCarousel extends StatefulWidget {
  final List<Event> events;
  final bool isPortrait;

  const EventCarousel({
    super.key,
    required this.events,
    required this.isPortrait,
  });

  @override
  State<EventCarousel> createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50.withValues(alpha: 0.3),
            Colors.amber.shade50.withValues(alpha: 0.2),
            Colors.orange.shade100.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.event_available,
                  color: Colors.deepOrange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'ඉදිරි දේශනා',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700,
                  ),
                ),
              ],
            ),
          ),

          // PageView Carousel - Use ConstrainedBox instead of SizedBox
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 320,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: EventCard(
                    title: event.title,
                    location: event.location,
                    contact: event.contact,
                    imageUrl: event.imageUrl,
                    eventDate: event.eventDate,
                  ),
                );
              },
            ),
          ),

          // Page Indicator (Dots)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.events.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: _currentPage == index
                        ? LinearGradient(
                            colors: [
                              Colors.deepOrange.shade700,
                              Colors.orange.shade600,
                            ],
                          )
                        : null,
                    color: _currentPage == index ? null : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),

          // Navigation Arrows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                GestureDetector(
                  onTap: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.shade700,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Previous',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Counter Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPage + 1} / ${widget.events.length}',
                    style: TextStyle(
                      color: Colors.deepOrange.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Next Button
                GestureDetector(
                  onTap: () {
                    if (_currentPage < widget.events.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.shade700,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

