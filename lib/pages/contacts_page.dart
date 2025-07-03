import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart'; // For Factory

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final String _mapHtml = '''
<!DOCTYPE html>
<html style="height: 100%; margin: 0;">
  <body style="height: 100%; margin: 0;">
    <iframe 
      src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3550.617646801235!2d80.14900677537268!3d7.271800695310801!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3ae31ef2065ea9e9%3A0x2296b227564d4029!2zUGFyYW1hIE5pYmJhbmEgRGhhcm1heWF0aGFuYXlhICjgtrTgtrvgtrgg4Lax4LeS4La24LeK4La24LeP4LaxIOC2sOC2u-C3iuC2uOC3j-C2uuC2reC2seC2uik!5e1!3m2!1sen!2slk!4v1750095724642!5m2!1sen!2slk"
      width="100%"
      height="100%"
      style="border:0;"
      allowfullscreen=""
      loading="lazy"
    ></iframe>
  </body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Page")),
      body: SingleChildScrollView(
        // <-- Makes the entire page scrollable
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Our Location",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text("Param Nibban Dharmayathanaya"),
            ),
            
            SizedBox(
              height: 400, // Fixed height for the map (can be adjusted)
              child: InAppWebView(
                initialData: InAppWebViewInitialData(data: _mapHtml),
                gestureRecognizers: {
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
