import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utills/colors.dart';
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
                      DetailsCard(
                        title: "සුවත්ථි හෝතු.",
                        decription:
                            "නිවන් අවබෝධ කරගැනීමට උපකාර වන පරිදි එසේ නොමැතිනම් රාගයෙන් දෝසයෙන් මෝහයෙන් සදහටම සහමුළින්ම මිදී නිදහස් වීමට උපකාර වන පරිදි යමෙකු යම් පරියායක් දේසනා කරන්නේද, ඒ උතුමන් ධම්මවාදියෙකු වන්නේය. මෙකල ධම්මවාදී සමාගමේ ආරම්භකයා ගොතම සමණ අප තථාගතයන් වහන්සේය. උන්වහන්සේගේ දේසනාරම්භයෙන් ආරම්භ වූ ගොතම බුද්ධ සාසනීය ධම්මවාදී සමාගම කලින් කලට ඉස්මතු වෙමින් යටපත් වෙමින් විපරිණාම ධම්මයට අනුවම පණ දහසක් කල් පවතින බව පරම සච්චතාවයකි. මේ කාලයද ඒ ආකාරයට ධම්මපරියාය නැවත ඉස්මතු වන යුගයකි. ධම්මපරියාය දේසනා කරන ධම්මවාදීන් ජීවමාන වූ කාලයකි, එම නිසා පුබ්බේත කත පුඤ්ඤතා ඇත්තන්ට සෝතාවධානේ පඤ්ඤා සුතමය ඤාණය ලබන්නට හැකිවන කාලයකි. ඒ අනුව සංවර පටිපදාවෙහි පිහිටා සම්මා විමුත්තියට පත්වන්නට හැකිවන කාලයකි. එම නිසා මේ සොබාදහම්තාවයෙන් සියලු ලෝක සියලු සත්ත්වයෝ සෝතාපන්න ඵලයෙන් නිදුක්වෙත්වා….!!! සකදාගාමී ඵලයෙන් නීරෝගී වෙත්වා….!!! අනාගාමී ඵලයෙන් සුවපත් වෙත්වා….!!! අරහත් ඵලයෙන් දුකින් මිදෙත්වා….!!! පරම නිබ්බාන සුවයෙන් සුවපත් වෙත්වා….!!! යන පරම පිවිතුරු මෙත්තා සහගත අධිට්ඨානයක් පැතිර වීම උතුම්ය.",
                        bgColor: detailCardBgColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DetailsCard(
                          title: "details Head",
                          decription: "Content Text here",
                          bgColor: secondTextCardBgColor)
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
