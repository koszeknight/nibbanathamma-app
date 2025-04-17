import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/pages/audio_page.dart';
import 'package:nibbana_dhamma/pages/books_page.dart';
import 'package:nibbana_dhamma/pages/home_page.dart';

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
        // Define the route for the audio page
        // Define a route for the settings page
        // Add more routes here for other pages in your app
      },
    );
  }
}
