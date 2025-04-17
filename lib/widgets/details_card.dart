import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utills/colors.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
          color: detailCardBgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black12, offset: Offset(0, 2)
                //blurRadius: 0,
                )
          ]),
    );
  }
}
