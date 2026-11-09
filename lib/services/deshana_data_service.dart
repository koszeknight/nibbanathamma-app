import 'package:flutter/foundation.dart';
// services/audio_stream_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioStreamService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Map<String, String>>> getBasicDeshanasStream() {
    return _firestore
        .collection('basic_deshanas')
        .orderBy('createdAt',
            descending: false) // Order by title if you want alphabetical order
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _convertToAudioMap(doc.data())).toList())
        .handleError((error) {
      debugPrint('Error in basic deshanas stream: $error');
      return <List<Map<String, String>>>[];
    });
  }

  static Stream<List<Map<String, String>>> getAdvancedDeshanasStream() {
    return _firestore
        .collection('advanced_deshanas')
        .orderBy('title') // Order by title if you want alphabetical order
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _convertToAudioMap(doc.data())).toList())
        .handleError((error) {
      debugPrint('Error in advanced deshanas stream: $error');
      return <List<Map<String, String>>>[];
    });
  }

  static Map<String, String> _convertToAudioMap(Map<String, dynamic> data) {
    return {
      "title": data['title']?.toString() ?? '',
      "url": data['url']?.toString() ?? '',
    };
  }
}

