import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/events_data.dart';
import 'package:nibbana_dhamma/utills/colors.dart';
import 'package:nibbana_dhamma/widgets/side_menu.dart';
import 'package:nibbana_dhamma/widgets/top_title_bar.dart';
import 'package:nibbana_dhamma/widgets/events_cards.dart'; // Import your EventCard widget

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
                                    "නිවන් අවබෝධ කරගැනීමට උපකාර වන පරිදි...",
                                bgColor: detailCardBgColor,
                                isPortrait: isPortrait,
                              ),
                              SizedBox(height: isPortrait ? 20 : 10),
                              ResponsiveDetailsCard(
                                title: "details Head",
                                description: "Content Text here",
                                bgColor: secondTextCardBgColor,
                                isPortrait: isPortrait,
                              ),
                              SizedBox(height: isPortrait ? 20 : 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Second part - Events ListView from Firebase
                Container(
                  height: 350,
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
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No upcoming events'));
                            }

                            final events = snapshot.data!.docs
                                .map((doc) => Event.fromFirestore(doc))
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
              fontSize: isPortrait ? 16 : 14,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
