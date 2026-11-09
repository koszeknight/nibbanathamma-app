// models/preacher_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Preacher {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? link;
  final String? dharmasanaUrl;

  Preacher({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.link,
    this.dharmasanaUrl,
  });

  factory Preacher.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Preacher(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      imageUrl: data['img_url']?.toString() ?? '',
      link: data['link']?.toString(),
      dharmasanaUrl: data['dharmasana_url']?.toString(),
    );
  }
}
