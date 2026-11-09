import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nibbana_dhamma/model/preacher_data.dart';

class PreacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all preachers - OLDEST FIRST
  Stream<List<Preacher>> getPreachers() {
    return _firestore
        .collection('document_Preachers')
        .orderBy('order',
            descending: false) // Changed to false for oldest first
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Preacher.fromFirestore(doc)).toList());
  }

  // Get preachers once (for non-stream usage) - OLDEST FIRST
  Future<List<Preacher>> getPreachersOnce() async {
    final snapshot = await _firestore
        .collection('document_Preachers')
        .orderBy('createdAt',
            descending: false) // Changed to false for oldest first
        .get();
    return snapshot.docs.map((doc) => Preacher.fromFirestore(doc)).toList();
  }

  // Alternative: If you want to order by a different field
  Stream<List<Preacher>> getPreachersByCustomOrder() {
    return _firestore
        .collection('document_Preachers')
        .orderBy('timestamp', descending: false) // Use your actual field name
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Preacher.fromFirestore(doc)).toList());
  }
}
