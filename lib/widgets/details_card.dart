import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  final String title;
  final String decription;
  final Color bgColor;

  const DetailsCard(
      {super.key,
      required this.title,
      required this.decription,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, offset: Offset(0, 2)
                  //blurRadius: 0,
                  )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                decription,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ));
  }
}
