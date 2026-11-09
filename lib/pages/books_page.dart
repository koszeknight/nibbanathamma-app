import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/book_cards.dart';
import '../services/book_service.dart';
import '../model/book_data.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final BookService _bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 228, 138),
      appBar: AppBar(
        title: const Text("Dhamma Books"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Book>>(
          stream: _bookService.getBooks(),
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Handle error state
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading books: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // Handle empty state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No books available',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Display books list
            final books = snapshot.data!;

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                // Add spacing between items except for the last one
                return Column(
                  children: [
                    BookCards(
                      bookName: book.bookName,
                      bookImagePath: book.bookImagePath,
                      pdfUrl: book.pdfUrl,
                    ),
                    if (index < books.length - 1) const SizedBox(height: 12),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
