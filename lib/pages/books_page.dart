import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/widgets/book_cards.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

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
        child: ListView(
          children: [
            BookCards(
              bookName:
                  "නිවනට අවබෝධ කර ගැනීමට උපකාර වන පරම පවිත්‍ර සිරි සද්ධර්මයසද්ධර්මය",
              bookImagePath: "assets/images/Paramsathiya.JPG",
              // pdfUrl: "https://drive.google.com/file/d/15Kqp0RlNQx3QvOrOYQOfdFopJCx5LJv-/view?usp=sharing",
              pdfUrl:
                  "https://drive.google.com/file/d/15Kqp0RlNQx3QvOrOYQOfdFopJCx5LJv-",
            ),
            const SizedBox(height: 12),
            BookCards(
              bookName: "දැනුම හා දැක්ම",
              bookImagePath: "assets/images/danumaHadhakkma.JPG",
              pdfUrl:
                  "https://drive.google.com/file/d/0B2m3yxwhl8zgYzliSlFROW14OGc/view?usp=sharing&resourcekey=0-x33zo273dviD_1TTCiOvBA",
            ),
            const SizedBox(height: 12),
            BookCards(
              bookName: "බුද්ධ බල - බුද්ධ ශක්ති බුද්ධ ඤාණ විග්‍රහය",
              bookImagePath: "assets/images/buddhaBala.JPG",
              pdfUrl:
                  "https://drive.google.com/file/d/1FQDqhVqkyMo_j7p1I0RNrpA0MSgbO_qv",
            ),
            const SizedBox(height: 12),
            BookCards(
              bookName:
                  "විමුක්ති මාර්ගය පෙන්වා වදාළ උතුමි බුද්ධ ධර්මය භක්තියෙන් අදහන බුද්ධාගමක් කරා පරිවර්ථනය වුයේ කෙසේ ද ?",
              bookImagePath: "assets/images/vimukathiDhamma.JPG",
              pdfUrl:
                  "https://docs.google.com/file/d/0B58eryIkHQavT09CQlZ3ZEtDMW8",
            ),
            const SizedBox(height: 12),
            BookCards(
              bookName: "ගෝතම බුදුන් වැඩසිටි දඹදිව හෙළයා හදුනා ගතයුත්තේ ඇයි ?",
              bookImagePath: "assets/images/GothamBudunWadasitidhamdhiwa.JPG",
              pdfUrl:
                  "https://drive.google.com/file/d/1UI0oHfCHpDxRPPI4Ms07TlVrifPHA3y2/view?usp=sharing",
            ),
            const SizedBox(height: 12),
            BookCards(
              bookName:
                  "සංසාර ණය ගනුදෙනු වලින් මිදී නිදහස් වෙන්නට උපකාර වන්නා වූ කරුණු හතරක්",
              bookImagePath: "assets/images/nayaGanudenu.JPG",
              pdfUrl:
                  "https://drive.google.com/file/d/19Ao-MD8Iv2d51nfa4NM3-tkI-9eXZrk_",
            ),
            const SizedBox(height: 12),
            BookCards(
              bookName: "බලන් කඩතුරා හැර දෑසේ",
              bookImagePath: "assets/images/balankadathura.JPG",
              pdfUrl:
                  "https://drive.google.com/file/d/1rtA7BxWrrYz9ZTFE5QnBmUNZh6QHEzHx",
            ),
            BookCards(
              bookName:
                  "Why should Hela People be congnizant of the Janbudeep of Buddha Gothama?",
              bookImagePath: "assets/images/Janbudeeoa_eng.JPG",
              pdfUrl:
                  "https://drive.google.com/file/d/1Dgya6g2ryASrRK33jACMXaQoWK8Yaj72",
            ),
          ],
        ),
      ),
    );
  }
}
