import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/linkList.dart';
import 'package:nibbana_dhamma/pages/home_page.dart';
import 'package:nibbana_dhamma/utills/colors.dart';
import 'package:nibbana_dhamma/widgets/details_cardHistory.dart';
import 'package:nibbana_dhamma/widgets/linkCardsItems.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hela Buddhist History"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ResponsiveDetailsCard(
                title: "වර්ථමානයේ හෙල ‌බෙදු ඉතිහාසය වැදගත් වන්නේ ඇයි ?",
                description:
                    "වර්ථමානයේ නිවන් අවබෝධ කර ගැනීමට පින්පිරූ පිරිසකට චතු අරිය සත්‍ය අවබෝධ කර ගැනීමට සහ බුදුන්වහන්සේ මහා පරිනිබ්බාන සූත්‍රයේ දේශනා කල සද්ධස්සඝ කුලපුත්තස්ස, දස්සනීයානං සංවේජනීයානං තත්වයට පත් වන්නට බුද්ධ ශක්තියට අනුගත වියහැකි ස්ථාන හතර නිවැරදිවත් පිරිසිදුවත් දැනගත යුතුයි.‍එසේම  ඉන්දියානු සම්බවයක් ඇති අටුවාචාරීන් වහන්සේලා අතින් ලියැවුනු අපේ හෙළබිමේ ඉතිහාසය සහ ඊට සමගාමීව විශුද්ධි මාර්ගය ගුරුකොට මේ දක්වා විකාශය වී ඇති බුදු දහම ඒ අයුරින්ම අර්ථකතනය කිරීම තුල සැඟවගිය, නිවන් මගත් හෙළබිමේ නිවැරදිවූත්, ඉතා පැහැදිලි සහ විද්‍යානුකූලවූත් ඉතිහාසය, නිවන් අවබෝධ කර ගැනීමට උපකාරවන ලෙස පරම පවිත්‍ර සිරි සද්ධර්මය ලෙස මතුකොට පෙන්වා දීම අත්‍යව්‍යය.ඉහත දැක්වූ පරිදි මෙලෙස ‌නිවැරදි හෙළ ඉතිහාසට අයත් කරුණු ඔබ සැමට ‌‌ගෙනහැර දක්වන්නේ ඔ‌බේ දහම් ඇස පහද‌ා දීම පිණිසමය.",
                bgColor: detailCardBgColor,
                isPortrait: isPortrait,
              ),
              SizedBox(height: isPortrait ? 20 : 10),
              Container(
                decoration: BoxDecoration(color: Colors.amberAccent),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "මහා පරිනිබ්බාන සූත්‍රයේ සදහන් පරිදි සද්ධස්සඝ කුලපුත්තස්ස, දස්සනීයානං සංවේජනීයානං තත්වයට පත් වන්නට බුද්ධ ශක්තියට අනුගත වියහැකි ස්ථාන හතර"),
                      ),
                      DetailsCardHistory(
                          title: "1. සිදුහත් කුමරු උපන් ස්ථානය",
                          ImagePath: "assets/images/Babaragala.jpg",
                          decription: "බබරගල රජමහා විහාරය - තෙල් දෙනිය",
                          bgColor: const Color.fromARGB(255, 207, 198, 198),
                          placeUrl:
                              "https://maps.google.com/?q=Babaragala+Rajamaha+Viharaya"),
                      SizedBox(
                        height: 20,
                      ),
                      DetailsCardHistory(
                          title: "2. උතුම් සම්බුද්ධත්වයට පත් වූ ස්ථානය​",
                          ImagePath:
                              "assets/images/history/2Sirimahabodhiya.jpg",
                          decription:
                              "හිරිවඩුන්න ශ්‍රී බෝධිරාජ ආරණ්‍ය සේනාසනය - හබරන",
                          bgColor: const Color.fromARGB(255, 207, 198, 198),
                          placeUrl:
                              "https://maps.app.goo.gl/otgaPAg9ffLfYXmu5"),
                      SizedBox(
                        height: 20,
                      ),
                      DetailsCardHistory(
                          title: "3.ප්‍රථම ධම්ම දේශනය කළ ස්ථානය​",
                          ImagePath: "assets/images/history/3isinBasagla.jpg",
                          decription:
                              "ඉසින්බැස්සගල රුවන්ගිරි රජමහා විහාරය -මැදවච්චිය",
                          bgColor: const Color.fromARGB(255, 207, 198, 198),
                          placeUrl:
                              "https://maps.app.goo.gl/ExyPZGH5fgoUAoJo7"),
                      SizedBox(
                        height: 20,
                      ),
                      DetailsCardHistory(
                        title: "4.පරිනිබ්බානයට පත් වූ ස්ථානය​",
                        ImagePath: "assets/images/history/4budugala.jpg",
                        decription: "බුදුගල රජමහා විහාරය - කල්තොට",
                        bgColor: const Color.fromARGB(255, 207, 198, 198),
                        placeUrl: "https://maps.app.goo.gl/ZAXgd27oNw7ccDse6",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Main Web Sites",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    LinkCardGrid(items: historyItems),
                    // Text("Youtube  Links",
                    //     style: const TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.bold,
                    //     )),
                    // SizedBox(height: 8),
                    // LinkCardGrid(items: YouLinkItem),
                    // SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
