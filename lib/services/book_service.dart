import 'package:flutter/foundation.dart';
// services/book_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/book_data.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'dhamma_books';

  // Stream to get all books
  Stream<List<Book>> getBooks() {
    return _firestore
        .collection(_collectionName)
        .orderBy('order', descending: false) // Add an 'order' field for sorting
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Optional: Get books once (if you don't need real-time updates)
  Future<List<Book>> getBooksOnce() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('order', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        return Book.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting books: $e');
      return [];
    }
  }
}

