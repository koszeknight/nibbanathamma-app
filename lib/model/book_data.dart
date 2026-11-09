// models/book_data.dart
class Book {
  final String id;
  final String bookName;
  final String bookImagePath;
  final String pdfUrl;

  Book({
    required this.id,
    required this.bookName,
    required this.bookImagePath,
    required this.pdfUrl,
  });

  // Convert Firebase document to Book object
  factory Book.fromFirestore(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      bookName: data['bookName']?.toString() ?? '',
      bookImagePath: data['bookImagePath']?.toString() ?? '',
      pdfUrl: data['pdfUrl']?.toString() ?? '',
    );
  }

  // Convert Book object to Map for Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'bookName': bookName,
      'bookImagePath': bookImagePath,
      'pdfUrl': pdfUrl,
    };
  }
}
