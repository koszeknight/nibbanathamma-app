import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/events_data.dart';
import 'package:nibbana_dhamma/model/linkList.dart';
import 'package:nibbana_dhamma/utills/colors.dart';
import 'package:nibbana_dhamma/widgets/linkCardsItems.dart';
import 'package:nibbana_dhamma/widgets/maindeshana.dart';
import 'package:nibbana_dhamma/widgets/side_menu.dart';
import 'package:nibbana_dhamma/widgets/top_title_bar.dart';
import 'package:nibbana_dhamma/widgets/events_cards.dart';
// Import your EventCard widget

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
                // First part - scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TopTitleBar(),
                          SizedBox(height: isPortrait ? 20 : 10),
                          Column(
                            children: [
                              ResponsiveDetailsCard(
                                title: "සුවත්ථි හෝතු.",
                                description:
                                    "නිවන් අවබෝධ කරගැනීමට උපකාර වන පරිදි එසේ නොමැතිනම් රාගයෙන් දෝසයෙන් මෝහයෙන් සදහටම සහමුළින්ම මිදී නිදහස් වීමට උපකාර වන පරිදි යමෙකු යම් පරියායක් දේසනා කරන්නේද, ඒ උතුමන් ධම්මවාදියෙකු වන්නේය. මෙකල ධම්මවාදී සමාගමේ ආරම්භකයා ගොතම සමණ අප තථාගතයන් වහන්සේය.උන්වහන්සේගේ දේසනාරම්භයෙන් ආරම්භ වූ ගොතම බුද්ධ සාසනීය ධම්මවාදී සමාගම කලින් කලට ඉස්මතු වෙමින් යටපත් වෙමින් විපරිණාම ධම්මයට අනුවම පණ දහසක් කල් පවතින බව පරම සච්චතාවයකි. මේ කාලයද ඒ ආකාරයට ධම්මපරියාය නැවත ඉස්මතු වන යුගයකි. ධම්මපරියාය දේසනා කරන ධම්මවාදීන් ජීවමාන වූ කාලයකි, එම නිසා පුබ්බේත කත පුඤ්ඤතා ඇත්තන්ට සෝතාවධානේ පඤ්ඤා සුතමය ඤාණය ලබන්නට හැකිවන කාලයකි. ඒ අනුව සංවර පටිපදාවෙහි පිහිටා සම්මා විමුත්තියට පත්වන්නට හැකිවන කාලයකි. එම නිසා මේ සොබාදහම්තාවයෙන් සියලු ලෝක සියලු සත්ත්වයෝ සෝතාපන්න ඵලයෙන් නිදුක්වෙත්වා….!!! සකදාගාමී ඵලයෙන් නීරෝගී වෙත්වා….!!! අනාගාමී ඵලයෙන් සුවපත් වෙත්වා….!!! අරහත් ඵලයෙන් දුකින් මිදෙත්වා….!!! පරම නිබ්බාන සුවයෙන් සුවපත් වෙත්වා….!!! යන පරම පිවිතුරු මෙත්තා සහගත අධිට්ඨානයක් පැතිර වීම උතුම්ය",
                                bgColor: detailCardBgColor,
                                isPortrait: isPortrait,
                              ),
                              SizedBox(height: isPortrait ? 20 : 10),
                            ],
                          ),

                          // Second part - Events ListView from Firebase
                          Container(
                            height: 400,
                            color: Colors.grey[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'Upcoming Events',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('events')
                                        .orderBy('date',
                                            descending:
                                                false) // Sort by date if you have it
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (snapshot.data!.docs.isEmpty) {
                                        return Center(
                                            child: Text('No upcoming events'));
                                      }

                                      final events = snapshot.data!.docs
                                          .map(
                                              (doc) => Event.fromFirestore(doc))
                                          .toList();

                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: horizontalPadding),
                                        itemCount: events.length,
                                        itemBuilder: (context, index) {
                                          final event = events[index];
                                          return Container(
                                            width: 300,
                                            margin: EdgeInsets.only(right: 12),
                                            child: EventCard(
                                              title: event.title,
                                              location: event.location,
                                              contact: event.contact,
                                              imageUrl: event.imageUrl,
                                              eventDate: event.eventDate,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // ResponsiveDetailsCard(
                          //   title: "මූලික දේශනා",
                          //   description: "Content Text here",
                          //   bgColor: secondTextCardBgColor,
                          //   isPortrait: isPortrait,
                          // ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    const Color.fromARGB(255, 214, 213, 209)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'මූලික දේශනා',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                SizedBox(height: 12),
                                // Use Column with manual cards
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

                                    // Add more cards as needed
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: isPortrait ? 20 : 10,
                          ),

                          SizedBox(
                            height: isPortrait ? 30 : 20,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Usefull Links",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 50, 157, 245),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          //  FooterLinksEdit(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Main Web Sites",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  LinkCardGrid(items: linkItems),
                                  Text("Youtube  Links",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 8), // Spacing
                                  // LinkList(links: otherLinks),

                                  LinkCardGrid(items: YouLinkItem),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: isPortrait ? 20 : 10),
                          //LinkCardGrid(items: linkItems),
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
