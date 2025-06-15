import 'package:flutter/material.dart';

class BookCards extends StatelessWidget {
  final String bookName;
  final String bookImagePath;

  const BookCards({
    super.key,
    required this.bookName,
    required this.bookImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 222, 238, 82)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                bookImagePath,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text(bookName)
            ],
          ),
        ));
  }
}
