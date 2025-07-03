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
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      location: data['location'] ?? 'Unknown Location',
      contact: data['contact'] ?? 'No Contact',
      imageUrl: data['imageURL'],
      eventDate: data['eventDate'] ?? "No EventDate",
      date: data['date']?.toDate(),
    );
  }
}
