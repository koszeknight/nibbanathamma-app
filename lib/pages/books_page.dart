import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/book_cards.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Books"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                BookCards(
                    bookName: "This is Name",
                    bookImagePath: "assets/images/sampleimage.jpg"),
                SizedBox(
                  height: 10,
                ),
                BookCards(
                    bookName: "This is Name",
                    bookImagePath: "assets/images/sampleimage.jpg"),
              ],
            ),
          ),
        ));
  }
}
