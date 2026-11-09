import 'package:cloud_firestore/cloud_firestore.dart'; // models/preacher_model.dart

class AudioData {
  final String id;
  final String title;
  final String url;

  AudioData({
    required this.id,
    required this.title,
    required this.url,
  });

  factory AudioData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AudioData(
      id: doc.id,
      title: data['title'] ?? '',
      url: data['url'] ?? '',
    );
  }
}
