import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String location;
  final String contact;
  final String? imageUrl;
  final String eventDate;
  final DateTime? date;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.contact,
    required this.eventDate,
    this.imageUrl,
    this.date,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime? parsedDate;
    final rawDate = data['date'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    }
    return Event(
      id: doc.id,
      title: data['title']?.toString() ?? 'No Title',
      location: data['location']?.toString() ?? 'Unknown Location',
      contact: data['contact']?.toString() ?? 'No Contact',
      imageUrl: data['imageURL']?.toString(),
      eventDate: data['eventDate']?.toString() ?? "No EventDate",
      date: parsedDate,
    );
  }
}
