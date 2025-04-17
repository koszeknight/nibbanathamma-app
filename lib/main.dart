import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/pages/audio_page.dart';
import 'package:nibbana_dhamma/pages/books_page.dart';
import 'package:nibbana_dhamma/pages/contacts_page.dart';
import 'package:nibbana_dhamma/pages/events_page.dart';
import 'package:nibbana_dhamma/pages/history_page.dart';
import 'package:nibbana_dhamma/pages/home_page.dart';
import 'package:nibbana_dhamma/pages/links_page.dart';
import 'package:nibbana_dhamma/pages/video_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nibbana Dhamma",
      //home: HomePage(),
      initialRoute: '/', // The route displayed when the app starts
      routes: {
        '/': (context) =>
            const HomePage(), // Define the route for the home page
        '/audio': (context) => const AudioPage(),
        '/books': (context) => const BooksPage(),
        '/video': (context) => const VideoPage(),
        '/events': (context) => const EventsPage(),
        '/links': (context) => const LinksPage(),
        '/contact': (context) => const ContactsPage(),
        '/history': (context) => const HistoryPage(),
        // Define the route for the audio page
        // Define a route for the settings page
        // Add more routes here for other pages in your app
      },
    );
  }
}
