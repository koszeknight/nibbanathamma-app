import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/details_card.dart';
import 'package:nibbana_dhamma/widgets/side_menu.dart';

import 'package:nibbana_dhamma/widgets/top_title_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SideMenu(),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopTitleBar(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      DetailsCard(),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
