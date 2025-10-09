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
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Preacher(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['img_url'] ?? '',
      link: data['link'],
      dharmasanaUrl: data['dharmasana_url'],
    );
  }
}
