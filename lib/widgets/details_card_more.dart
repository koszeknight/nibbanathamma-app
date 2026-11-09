import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utils/app_url_launcher.dart';

class DetailsCardMore extends StatefulWidget {
  final String title;
  final String decription;
  final String imagePath;
  final String placeUrl;
  final Color bgColor;

  const DetailsCardMore({
    super.key,
    required this.title,
    required this.placeUrl,
    required this.imagePath,
    required this.decription,
    required this.bgColor,
  });

  @override
  State<DetailsCardMore> createState() => _DetailsCardUrlState();
}

class _DetailsCardUrlState extends State<DetailsCardMore> {
  bool _isExpanded = false;

  Future<void> _launchUrl() async {
    await AppUrlLauncher.openUrl(
      context,
      widget.placeUrl,
      title: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.decription,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            // Expandable section
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? "Hide Details" : "View Details",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        // Add your additional details here
                        Text(
                          "පරම සත්‍ය පෙන්වා වදාළ​ අති පූජනීය බුද්ධ පුත්‍ර මීවනපළානේ සිරි ධම්මාලංකාර මහ තෙරුණ් වහන්සේ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                            "1942 අපේ‍්‍රල් මස 12 වන දින රයිගම් කෝර්ළයට අයත් මීවනපළාන ග‍්‍රාමයේ පදිංචි විලියම් හපුතන්ත‍්‍රී සහ ඇලිස් හපුආරච්චි යන ප‍්‍රභූ දෙපළ පුත් රුවනක් ලදහ. තමන්ගේ පළමු පිරිමි දරුවා වූ මෙම කුල කුමරුවා සිරිසේන හපුතන්තී‍්‍ර යනුවෙන් නම් තැබූහ. කල්ගත වෙද්දී සිරිසේන හපුතන්ත‍්‍රී දරුවා සහෝදර සහෝදරියන් පස් දෙනෙකු මැද සියලූ සැප සම්පත් ලැබ හැදී වැඩුනේය. \n \n මීවනපළානේ (තම ගමේ) රජයේ විද්‍යාලයෙන් ප‍්‍රාථමික අධ්‍යාපනය හදාරා පසුව ද්විතීයක අධ්‍යාපනය සඳහා හොරණ තක්‍ෂිලා මධ්‍ය මහා විද්‍යාලයට ඇතුළත් වූ සිරිසේන හපුතන්ත‍්‍රී, විදුහලේ දීප්තිමත් ශිෂ්‍යයෙකු වශයෙන් තම සරසවි පිවිසුම් පෙළ විභාගය ඉහළින්ම සමත් වූයේය. ඒ 1962 වර්ෂයේදීය​. වර්ෂ 1963 පේරාදෙණි සරසවියට ඇතුළත් වීමට වරම් ලද මොහු සංඛ්‍යා ලේඛණය හා ආර්ථික විද්‍යාව යන විෂය ධාරාවන්ගෙන් විශේෂ උපාධියක් ලබා උසස් අධ්‍යාපනය ලැබීය. \n \n පේරාදෙණිය සරසවියෙන් උපාධිය දක්වා අධ්‍යාපනය ලැබුවද ඉන් නොනැවතුණු හපුතන්තී‍්‍ර ශිෂ්‍යයා තම පශ්චාත් උපාධි අධ්‍යාපන කටයුතු සඳහා විදෙස් ගත විය. මේ අනුව හේග් විශ්ව විද්‍යාලයෙන් කෘෂිකර්මය හා සංඛ්‍යා ලේඛණය පිළිබඳව පශ්චාත් උපාධියත්, ඇමෙරිකාවේ නෝර්ත් කැරොලිනා රාජ්‍ය විශ්ව විද්‍යාලයෙන් ආර්ථික විද්‍යා විශ්ලේෂණය පිළිබඳ පශ්චාත් උපාධියත් ඔහු සාර්ථකව සම්පූර්ණ කරන ලදී. \n \n වර්ෂ 1968 වන විට සිරිසේන හපුතන්ත‍්‍රී මහතා කෘෂිකර්ම, ආහාර හා සමූපාකාර අමාත්‍යාංශයේ සංඛ්‍යා ලේඛණඥයෙකු ලෙස තම මුල්ම රැකියාවේ වැඩ භාර ගන්නට යෙදිණි. රජයේ සේවකයෙකු ලෙස අවංකව සහ ඉතා කැපවීමෙන් තම දායකත්වය රාජ්‍ය අංශය වෙත ලබා දෙමින් රටට වැඩදායී, විශේෂයෙන්ම රටේ ජීවනාලය බඳු වූ ගොවි ජනතාවට වැඩදායී බොහෝ ව්‍යාපෘතීන් ක‍්‍රියාවට නැගුනේ සිරිසේන හපුතන්ත‍්‍රී මහතාගේ මූලිකත්වයෙනි. තම රාජ්‍ය සේවා කාලය තුළ විදෙස් රටවල් 60 ක පමණ සංචාරය කර අත්දැකීම් ලද හපුතන්තී‍්‍ර මහතා වර්ෂ 2002 දී විශ‍්‍රාම ලබන විට කෘෂිකර්ම අමාත්‍යාංශයේ 'අධ්‍යක්‍ෂ ජනරාල්' ධූරය හොබවමින් සිටියේය.\n \n ඉතා සාර්ථක පවුල් ජීවිතයක් ගත කළ සිරිසේන හපුතන්තී‍්‍ර මහතාගේ බිරිඳ වූයේ දිවයිනේ ප‍්‍රධාන බාලිකා පාසල් කිහිපයක විදුහල්පති තනතුර දැරූ ගුරු මාතාවකි. දරුවන් දෙදෙනෙකුගේ පියෙකු වූ මෙතුමා ඉතා හොඳ ආර්ථික තත්ත්වයකින් සහ සමාජයීය තත්ත්වයකින් ජීවිතය ගත කළද විශ‍්‍රාම දිවිය ඇරඹුමත් සමග නොසිතූ පරිවර්තනයකට ලක් වෙමින් බුදු දහම කෙරේ දැඩි නැඹුරුතාවයක් පෙන්නුම් කළේය. පසුව​ හපුතන්ත‍්‍රී මහතා කුරුණෑගල ප‍්‍රදේශයේ ආරණ්‍ය සේනාසනයක අවුරුද්දක පමණ කාලයක් භාවනානුයෝගීව සිට තමා පිරිසිඳ දැක ගැනීමේ ආධ්‍යාත්මික මෙහෙයුමක නියැලෙන්නට විය. එමතුද නොව තමන් අවබෝධ කරගත් ධර්මය අන්‍යයන් අතරේ බෙදා හරින්නට වචන වලට පෙරළා ග‍්‍රන්ථාරූඪ කරමින් නොමිලේ බෙදා දෙන්නටද කටයුතු කළේය ගිහියෙකු වශයෙන් සිටියද ධර්මය දේශනා කරමින් සැඟව ගිය දහම් අරුත් යළි මතු කරන්නට ගත් උත්සාහය දහම් පිපාසයකින් සිටි බොහෝ දනන්ගේ ප‍්‍රබෝධයට හේතු විය. මෙසේ කාලය ගෙවී යද්දී වර්ෂ 2007 අගෝස්තු මස 15 වෙනිදා රත්නපුර, අමරපුර නිකායේ මහානායක පූජ්‍ය මඩලගම වජිරබුද්ධි ස්වාමීන් වහන්සේ අභිමුව තම ගිහි දිවියට සමුදුන් සිරිසේන හපුතන්ත‍්‍රී මහතා පා සිවුරු ගෙන මීවනපලානේ සිරි ධම්මාලංකාර නමින් පැවිදි දිවියට ඇතුළත් වූහ. \n \n එදා සිට අද දක්වා අනන්ත සංසාර ගමනේ කල් ගෙවමින්, දුක් විඳිමින් පිපාසයට බොර දිය මිස පිරිසිදු පැන් පොදක් නොලද බොහෝ ගිහි පැවිදි පුහුදුන් දනන් හට දහම් පිපාසාව නිවාලන්නට මඩ, රොඩු කුණු වලින් තොර සුපැහැදිලි පැන් පොදක් සොයා ගන්නට අවකාශ විවර කර දෙමින් සිරි සදහම් පණිවිඩය සුවහසක් ලෝක සත්ත්වයාගේ හිත සුව පිණිස මුදා හරිමින් යුග මෙහෙවරක නියැලී සිටින සේක.\n \n අද හෙළ බිමේ පමණක් නොව මේ පෘථිවි තලය ඇතුළු සියලූ ලෝක සියලූ සත්ත්වයින්ටම තම විමුක්තිය පිණිස, තම නිවීම පිණිස, තම අධිගමය පිණිස ඉවහල් වන පරම පවිත‍්‍ර සිරි සද්ධර්මයම දේශණා කරන උන්වහ්න්සේ කිසි දිනෙක මා කියන දේ ඒ ආකාරයෙන්ම පිළිගන්න යැයි දෙසා වදාරා නැත.තම තමන්ගේ විමර්ශන ඥාණයම උපයෝගි කරගෙන ධර්මය හේතු ඵල න්‍යායන් හා සැසඳේ නම් පමණක් භාර ගන්න. එයින් තමන්ගේ විමුක්තියට යම් සේ මහෝපකාරී වේද එයම ප‍්‍රතිපදාව කර ගන්න යැයි සිහනද​ කළ උන්වහන්සේ මෙම කෙටි කාලය තුළ දිවයිනේ නොයෙක් ප‍්‍රදේශවලට වඩිමින් නිමල නිකළැල් බුද්ධ දේශණාව පණ පොවමින් තම ශ‍්‍රාවකයින්ට මඟ ඵල ලබා නිවනින් සැනසෙන්නට උපකාරි වන සද්ධර්මය දේශණා කරමින් සිටී. මීවනපලානේ හිමියන් තම වයස ගැනද නොතකා පුහුදුන් ලෝක සත්ත්වයා වෙනුවෙන් සිදුකරන මෙම යුග මෙහෙවර මේ වන විට ඉතා වැදගත් සංධිස්ථානයක් කරා එළඹ ඇත.",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.justify),
                        SizedBox(height: 10),
                        if (widget.placeUrl.isNotEmpty)
                          GestureDetector(
                            onTap: _launchUrl,
                            child: const Text(
                              "Open link",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
