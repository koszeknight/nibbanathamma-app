import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utills/colors.dart';

class TopTitleBar extends StatelessWidget {
  const TopTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(
              236, 255, 223, 83)), // Background color of the top bar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 146, 64, 9)),
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "නිබ්බාන ධම්ම",
                  style: TextStyle(
                      fontSize: 22,
                      color: mainTextColor,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Nibbana Dhamma",
              style: TextStyle(
                  fontSize: 15,
                  color: mainTextColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
